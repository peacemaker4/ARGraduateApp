using FlutterUnityIntegration;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlutterCommunication : MonoBehaviour
{
    UnityMessageManager messageManager;

    void Start()
    {
        messageManager = GetComponent<UnityMessageManager>();

        MessageToFlutter("Started");
    }

    public void MessageToFlutter(string msg)
    {
        messageManager.SendMessageToFlutter(msg);
    }

}
