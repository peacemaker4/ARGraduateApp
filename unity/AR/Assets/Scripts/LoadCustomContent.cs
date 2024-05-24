using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;
using TMPro;
using System.IO;
using System.Collections;
using UnityEngine.Networking;
using FlutterUnityIntegration;
using System.Collections.Generic;
using System;
using static UnityEngine.GraphicsBuffer;
using UnityEditor;

public class LoadCustomContent : MonoBehaviour
{
    [SerializeField] ARTrackedImageManager mARTrackedImageManager;

    MutableRuntimeReferenceImageLibrary myRuntimeReferenceImageLibrary;

    [SerializeField] GameObject videoPrefab;

    [SerializeField] GameObject modelPrefab;

    private void Start()
    {
        myRuntimeReferenceImageLibrary = mARTrackedImageManager.CreateRuntimeLibrary() as MutableRuntimeReferenceImageLibrary;

        //Texture2D texture = new Texture2D(8, 8);
        //texture.LoadImage(byteArray);

        LoadContent("{\"content\": [{\"file_name\": \"0.obj\", \"file_url\": \"https://firebasestorage.googleapis.com/v0/b/argraduateapp.appspot.com/o/users%2Far%2F3D%2F0.obj?alt=media&token=f3dcdbd3-7de2-49f7-9b2d-30c63af8a506\", \"img_name\": \"0.jpg\", \"img_url\": \"https://firebasestorage.googleapis.com/v0/b/argraduateapp.appspot.com/o/users%2Far%2Fimage%2F0?alt=media&token=d81ef74e-6614-46cf-9bcb-a811eee20ce8\",\"uid\": \"aLcNSExXOIOIQTcQeU5i4cDy1WD2\", \"type\": \"3Dmodel\", \"texture_url\": \"https://firebasestorage.googleapis.com/v0/b/argraduateapp.appspot.com/o/users%2Far%2F3D%2F0_texture?alt=media&token=e260a40a-41bb-4dd7-a3b2-9d29b77d5176\"}]}");

        //var texture = Resources.Load("Spider") as Texture2D;
        //Debug.Log("Texture Name:" + texture.name);
        //Unity.Jobs.JobHandle jobHandle = myRuntimeReferenceImageLibrary.ScheduleAddImageJob(texture, "Spider", 0.2f);
        //jobHandle.Complete();

        //if (myRuntimeReferenceImageLibrary != null)
        //{
        //    Debug.Log("myRuntimeReferenceImageLibrary: " + myRuntimeReferenceImageLibrary.count);
        //    Debug.Log("supportedTextureFormatCount: " + myRuntimeReferenceImageLibrary.supportedTextureFormatCount);

        //    mARTrackedImageManager.referenceLibrary = myRuntimeReferenceImageLibrary;
        //}
        //mARTrackedImageManager.maxNumberOfMovingImages = 1;
        //mARTrackedImageManager.trackedImagePrefab = mTrackedImagePrefab;
        //mARTrackedImageManager.enabled = true;
    }

    public void LoadContent(string content)
    {
        var data = JsonUtility.FromJson<ARContentCollection>(content);

        //print(data.ToString());

        //var msg_manager = GameObject.FindWithTag("UnityMessageManager");
        //msg_manager.GetComponent<FlutterCommunication>().MessageToFlutter(data.ToString());

        StartCoroutine(PopulateImageLibrary(data.content));
    }

    IEnumerator PopulateImageLibrary(ARContent[] content)
    {
        var count = 0;

        foreach (ARContent c in content)
        {
            yield return GetTexture(c, count);
            count++;
        }

        if (myRuntimeReferenceImageLibrary != null)
        {
            mARTrackedImageManager.referenceLibrary = myRuntimeReferenceImageLibrary;

            var msg_manager = GameObject.FindWithTag("UnityMessageManager");
            msg_manager.GetComponent<FlutterCommunication>().MessageToFlutter("Loaded: " + mARTrackedImageManager.referenceLibrary.count.ToString());
        }
    }

    IEnumerator GetTexture(ARContent media, int count)
    {
        UnityWebRequest www = UnityWebRequestTexture.GetTexture(media.img_url);
        yield return www.SendWebRequest();
        AddReferenceImageJobState job;

        if (www.result != UnityWebRequest.Result.Success)
        {
            Debug.Log(www.error);
        }
        else
        {
            Texture2D myTexture = ((DownloadHandlerTexture)www.downloadHandler).texture;

            if (myTexture.isReadable)
            {
                var name = "img" + count.ToString();
                job = myRuntimeReferenceImageLibrary.ScheduleAddImageWithValidationJob(myTexture, name, 0.1f);

                GameObject obj = null;

                if(media.type == "3Dmodel")
                {
                    obj = Instantiate(modelPrefab, new Vector3(0, 0, 0), Quaternion.identity);
                    //obj = PrefabUtility.InstantiatePrefab(modelPrefab) as GameObject;
                    obj.name = name;
                    obj.GetComponent<LoadModelFromURL>().model_url = media.file_url;
                    obj.GetComponent<LoadModelFromURL>().texture_url = media.texture_url;
                    GetComponent<PlaceTrackedImages>().ArPrefabs.Add(obj);
                    obj.SetActive(false);
                }
                if (media.type == "video")
                {
                    obj = Instantiate(videoPrefab, new Vector3(0, 0, 0), Quaternion.identity);
                    Instantiate(videoPrefab);
                    //obj = PrefabUtility.InstantiatePrefab(videoPrefab) as GameObject;
                    obj.name = name;
                    obj.GetComponent<SetVideoURL>().url = media.file_url;
                    GetComponent<PlaceTrackedImages>().ArPrefabs.Add(obj);
                    obj.SetActive(false);
                }

                //var clone = PrefabUtility.InstantiatePrefab(Selection.activeObject as GameObject) as GameObject;

                //GetComponent<PlaceTrackedImages>().ArPrefabs[count] = 

                yield return new WaitUntil(() => job.jobHandle.IsCompleted);
            }
        }
    }

    [Serializable]
    public class ARContent
    {
        public string uid;
        public string type;
        public string img_url;
        public string file_name;
        public string file_url;
        public string img_name;
        public string texture_url;
    }

    [Serializable]
    public class ARContentCollection
    {
        public ARContent[] content;
    }
}
