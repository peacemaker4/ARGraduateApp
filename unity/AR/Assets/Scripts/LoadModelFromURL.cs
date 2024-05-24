using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;
using Dummiesman;
using System.IO;
using System.Text;
using System;
using TMPro;
using UnityEditor;

public class LoadModelFromURL : MonoBehaviour
{
    private GameObject model;

    public Material material1;

    public string model_url = "";

    public string texture_url = "";

    public float scale = 0.0025f;

    void Start()
    {
        //var model_url = "https://firebasestorage.googleapis.com/v0/b/argraduateapp.appspot.com/o/users%2Far%2F3D%2F0.obj?alt=media&token=f3dcdbd3-7de2-49f7-9b2d-30c63af8a506";

        //var texture_url = "https://firebasestorage.googleapis.com/v0/b/argraduateapp.appspot.com/o/users%2Far%2F3D%2F0_texture?alt=media&token=e260a40a-41bb-4dd7-a3b2-9d29b77d5176";

        //var scale = 0.0025f;

        StartCoroutine(Get3DModel(model_url, texture_url, scale));
    }

    IEnumerator Get3DModel(string MediaUrl, string TextureUrl, float scale)
    {
        UnityWebRequest www = UnityWebRequest.Get(MediaUrl);
        UnityWebRequest www2 = UnityWebRequestTexture.GetTexture(TextureUrl);

        yield return www.SendWebRequest();
        yield return www2.SendWebRequest();

        if (www.result != UnityWebRequest.Result.Success && www2.result != UnityWebRequest.Result.Success)
        {
            Debug.Log(www.error);
        }
        else
        {
            MemoryStream memoryStream = new MemoryStream(Encoding.UTF8.GetBytes(www.downloadHandler.text));
            if(model != null)
            {
                Destroy(model);
            }
            Texture2D myTexture = ((DownloadHandlerTexture)www2.downloadHandler).texture;

            //model = new OBJLoader().Load(memoryStream, this.gameObject, material1, scale); //, material, scale

            if (myTexture.isReadable)
            {
                //Material material = new Material(Shader.Find("Universal Render Pipeline/Lit"));
                material1.mainTexture = (Texture)myTexture;
                //material1.SetTexture("_MainTex", (Texture)myTexture);

                model = new OBJLoader().Load(memoryStream, this.gameObject, material1, scale); //, material, scale
            }
            else
            {
                model = new OBJLoader().Load(memoryStream, this.gameObject);
            }

        }
    }

    private void DoublicateFaces()
    {
        for (int i = 0; i < model.GetComponentsInChildren<Renderer>().Length; i++) // Loop through the model children

        {

            // Get original mesh components: vertices, normals, triangles, and texture coordinates

            Mesh mesh = model.GetComponentsInChildren<MeshFilter>()[i].mesh;

            Vector3[] vertices = mesh.vertices;

            int numOfVertices = vertices.Length;

            Vector3[] normals = mesh.normals;

            int[] triangles = mesh.triangles;

            int numOfTriangles = triangles.Length;

            Vector2[] textureCoordinates = mesh.uv;



            if (textureCoordinates.Length < numOfTriangles) // Check if the mesh doesn't have texture coordinates

            {

                textureCoordinates = new Vector2[numOfVertices * 2];

            }



            // Create a new mesh component, double the size of the original

            Vector3[] newVertices = new Vector3[numOfVertices * 2];

            Vector3[] newNormals = new Vector3[numOfVertices * 2];

            int[] newTriangles = new int[numOfTriangles * 2];

            Vector2[] newTextureCoordinates = new Vector2[numOfVertices * 2];



            for (int j = 0; j < numOfVertices; j++)

            {

                newVertices[j] = newVertices[j + numOfVertices] = vertices[j]; // Copy original vertices to make the second half of the new vertices array

                newTextureCoordinates[j] = newTextureCoordinates[j + numOfVertices] = textureCoordinates[j]; // Copy original texture coordinates to make the second half of the new texture coordinates array

                newNormals[j] = normals[j]; // First half of the new normals array is a copy of original normals

                newNormals[j + numOfVertices] = -normals[j]; // Second half of the new normals array reverses the original normals

            }



            for (int x = 0; x < numOfTriangles; x += 3)

            {

                // Copy the original triangle for the first half of the array

                newTriangles[x] = triangles[x];

                newTriangles[x + 1] = triangles[x + 1];

                newTriangles[x + 2] = triangles[x + 2];



                // Reversed triangles for the second half of the array

                int j = x + numOfTriangles;

                newTriangles[j] = triangles[x] + numOfVertices;

                newTriangles[j + 2] = triangles[x + 1] + numOfVertices;

                newTriangles[j + 1] = triangles[x + 2] + numOfVertices;

            }



            mesh.vertices = newVertices;

            mesh.uv = newTextureCoordinates;

            mesh.normals = newNormals;

            mesh.triangles = newTriangles;

        }

    }
}
