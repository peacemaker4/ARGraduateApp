using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class SetVideoURL : MonoBehaviour
{
    public VideoPlayer videoPlayer;
    public string url;
    //public Material image_material;
    public Texture2D mat_texture;

    public GameObject quad;
    //public AudioSource audioSource;

    private void Awake()
    {
        //videoPlayer.audioOutputMode = VideoAudioOutputMode.AudioSource;
        //videoPlayer.controlledAudioTrackCount = 1;
        //videoPlayer.EnableAudioTrack(0, true);
        //videoPlayer.SetTargetAudioSource(0, audioSource);
        videoPlayer.url = url;

        Material myNewMaterial = new Material(Shader.Find("Universal Render Pipeline/Lit"));
        //myNewMaterial.SetTexture("_MainTex", mat_texture);
        myNewMaterial.mainTexture = (Texture)mat_texture;

        //image_material.mainTexture = (Texture)mat_texture;
        quad.transform.localScale = new Vector3(1.025f, 1.025f, 1.025f);
        quad.GetComponent<MeshRenderer>().materials = new Material[] { myNewMaterial }; // image_material
    }
}
