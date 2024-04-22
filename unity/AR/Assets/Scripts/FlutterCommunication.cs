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

        messageManager.SendMessageToFlutter("Started");
    }

}
