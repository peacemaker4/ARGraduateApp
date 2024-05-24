import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ar_app/models/ARContent.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../auth.dart';
import '../firebasedb.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io' as io;

class ModelsList extends StatefulWidget {
  @override
  _ModelsListState createState() => _ModelsListState();
}

class _ModelsListState extends State<ModelsList> {
  var db_ref = FirebaseDB().firebaseRTDB.ref('content/${Auth().currentUser?.uid}/').once();
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db_ref, 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var curr_count = snapshot.data!.snapshot.children.where((x) => x.child("type").value == "3Dmodel").length;
          if(curr_count > 0){
            return Scaffold(
              body: FirebaseAnimatedList(
                query: FirebaseDB().firebaseRTDB.ref('content/${Auth().currentUser?.uid}/'),
                itemBuilder: (context, snapshot, animation, index){
                  if(snapshot.child("type").value.toString() == "3Dmodel"){
                    return Card(
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            Image.network(snapshot.child("texture_url").value.toString(), width: 32, height: 32,),
                            // Icon(Icons.all_out_rounded, size: 30,),
                        ],
                      ),
                      title: Text(snapshot.child("file_name").value.toString()),
                      subtitle: Text("3D Model"),
                    ),
                  );
                  }
                  return SizedBox.shrink();
                },
              ),
            );
          }
          else{
            return Scaffold(
              body: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("3D models not available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported_outlined, color: Colors.grey,)],) 
              ),
            );
          }
        }
        return Scaffold(
          body: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("3D models not available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
          ),
        );
      });

    
    
  }

}