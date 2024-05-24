import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ar_app/models/ARContent.dart';
import 'package:flutter_ar_app/pages/exit.dart';
import 'package:flutter_ar_app/pages/nav.dart';
import 'package:flutter_ar_app/widget_tree.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../auth.dart';
import '../firebasedb.dart';

class ARPage extends StatefulWidget {
  const ARPage({Key? key}) : super(key: key);

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
      body:SafeArea(
          bottom: false,
          child: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Container(
              color: Color.fromARGB(255, 0, 0, 0),
              child: UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnitySceneLoaded: onUnitySceneLoaded,
                onUnityMessage: onUnityMessage,
                fullscreen: true,
              ),
            ) ,
          ),
      ) 
    );
  }

  void sendAvailableContext() {
    var content = null;
    
    var ft = FirebaseDB().firebaseRTDB.ref('content/${Auth().currentUser?.uid}/').once();

    ft.then((value){
      var curr_count = value.snapshot.children.length;

      // var list = value.snapshot.children.toList();

      // List<Map<String, dynamic>> mappedList = list.map((obj) {
      //   return {
      //     'uid': obj.uid,
      //     'type': obj.type,
      //     'img_url': obj.image_url,
      //     'file_url': obj.file_url,
      //     'img_name': obj.image_name,
      //     'file_name': obj.file_name,
      //     'texture_url': obj.texture_url,
      //   };
      // }).toList();

      // var data = list.map((e) => jsonEncode(e));

      

      var data = value.snapshot.value as Map;

      // Fluttertoast.showToast(
      //   msg: '${data.toString()}',
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

      var json = jsonEncode(data.values.toList());

      _unityWidgetController?.postMessage(
        "XR Origin (XR Rig)",
        "LoadContent",
        json
      );

    });

    
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
    sendAvailableContext();
  }

  void onUnityMessage(message) {
    if(message.toString() == "Started"){
      // sendAvailableContext();
      
    }
    else{
      Fluttertoast.showToast(
        msg: '${message.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purple,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
    
  }

  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      
    }
  }
}