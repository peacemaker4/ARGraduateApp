import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/ar_info.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';

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

    context.loaderOverlay.show();

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          bottom: false,
          child: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Container(
                child: UnityWidget(
                  onUnityCreated: onUnityCreated,
                  onUnitySceneLoaded: onUnitySceneLoaded,
                  onUnityMessage: onUnityMessage,
                  fullscreen: false,
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
      context.loaderOverlay.hide();
    }

    Fluttertoast.showToast(
        msg: '${message.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
  }

  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    // Fluttertoast.showToast(
    //     msg: 'Unity',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    //   );
    if (sceneInfo != null) {
      
    }
  }
}