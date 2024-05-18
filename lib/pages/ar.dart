import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/exit.dart';
import 'package:flutter_ar_app/pages/nav.dart';
import 'package:flutter_ar_app/widget_tree.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(message) {
    if(message.toString() == "Started"){
      
    }

    // Fluttertoast.showToast(
    //     msg: '${message.toString()}',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    //   );
  }

  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      
    }
  }
}