using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class SetVideoURL : MonoBehaviour
{
    public VideoPlayer videoPlayer;
    public string url;
    public Material image_material;
    public Texture2D mat_texture;

    public GameObject quad;

    private void Awake()
    {
        videoPlayer.url = url;
        image_material.mainTexture = (Texture)mat_texture;
        quad.transform.localScale = new Vector3(1.025f, 1.025f, 1.025f);
        quad.GetComponent<MeshRenderer>().materials = new Material[] { image_material };
    }

}
