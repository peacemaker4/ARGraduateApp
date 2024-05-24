using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class SetVideoURL : MonoBehaviour
{
    public VideoPlayer videoPlayer;
    public string url;

    private void Awake()
    {
        videoPlayer.url = url;
        videoPlayer.Play();
    }

}
