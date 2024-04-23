import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/ar.dart';
import 'package:flutter_ar_app/pages/ar_info.dart';
import 'package:flutter_ar_app/pages/exit.dart';
import 'package:flutter_ar_app/pages/nav.dart';
import 'package:flutter_ar_app/pages/nav_ar.dart';
import 'package:flutter_ar_app/widget_tree.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UnityInitPage extends StatefulWidget {
  const UnityInitPage({Key? key}) : super(key: key);

  @override
  State<UnityInitPage> createState() => _UnityInitPageState();
}

class _UnityInitPageState extends State<UnityInitPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          bottom: false,
          child: PopScope(
            canPop: true,
            onPopInvoked : (_) async {
            },
            child: Container(
                child: UnityWidget(
                  onUnityCreated: onUnityCreated,
                  fullscreen: true,
                ),
            ) ,
          ),
      ) 
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    Navigator.pop(context);
    controller.pause();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavArPage()),
    );
  }

}