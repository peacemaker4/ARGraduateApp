import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
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
    sendAvailableContext();
    return Scaffold(
      key: _scaffoldKey,
      body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
                child: UnityWidget(
                  onUnityCreated: onUnityCreated,
                  onUnitySceneLoaded: onUnitySceneLoaded,
                  onUnityMessage: onUnityMessage,
                  fullscreen: false,
                ),
              ),
              
           
            ]
    )));
  }

  void sendAvailableContext() {
    var content = null;
    
    var ft = FirebaseDB().firebaseRTDB.ref('users/${Auth().currentUser?.uid}/').once();

    var ft2 = FirebaseDB().firebaseRTDB.ref('content/').once();

    var ft3 = FirebaseDB().firebaseRTDB.ref('users/').once();


    // FirebaseDB().firebaseRTDB.ref('content/').once().then((value){
    //   var data = value.snapshot.value as Map;

    //   // var json = jsonEncode(data.values.toList());

    //   Fluttertoast.showToast(
    //     msg: '${value.snapshot.value}',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.purple,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    //   );


    // });



    ft.then((value){
      var group = value.snapshot.child("group").value;
      FirebaseDB().firebaseRTDB.ref('users/').once().then((users){
        FirebaseDB().firebaseRTDB.ref('content/').once().then((content){
          var list_content =  List<Object>.empty(growable: true);
          for(var i in content.snapshot.children){
            var match = users.snapshot.children.where((x) => x.child("group").value == group && x.child("uid").value == i.child("uid").value.toString());
            if(match.length > 0){
              list_content.add(i.value!);
            }
          }
          
          var json = jsonEncode(list_content.toList());

          var input = "{\"content\": ${json}}";

          _unityWidgetController?.postMessage(
            "LoadCustomContent",
            "LoadContent",
            input
          );

        });
      });
    });


  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
    
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