import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/models/Group.dart';
import 'package:flutter_ar_app/pages/group_add_form.dart';
import 'package:flutter_ar_app/pages/group_members_page.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fb_storage.dart';
import 'ar_content_add_form.dart';

class ContentPage extends StatefulWidget {
  ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {

  var db_ref = FirebaseDB().firebaseRTDB.ref('content');

  TextEditingController searchTextController = TextEditingController();

  var _query = "";

  @override
  Widget build(BuildContext context){
    
    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('users/').once(), 
      builder: (context, snapshotf){
        return RefreshIndicator(
          onRefresh:() async {
            setState(() {
              
            });
        },
        child: Scaffold(
            appBar: AppBar(title: _search(), centerTitle: true, backgroundColor: Colors.white, foregroundColor: AppColors.primaryColor, ),
            floatingActionButton: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10), child: 
              FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                elevation: 10,
                tooltip: 'Add content',
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ARContentAddFormPage()),
                  );
                },
                child: const Icon(Icons.add_photo_alternate, color: Colors.white, size: 24),
              )
            ),
            body: FirebaseAnimatedList(
              defaultChild: 
                Center(
                  child: SpinKitRipple(
                      color: AppColors.primaryColor,
                      size: 50.0,
                  )
                ),
              query: db_ref,
              itemBuilder: (context, snapshot, animation, index){
                if(snapshot.child("img_name").value.toString().startsWith(_query)){
                  return Card(
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                          // Icon(Icons.groups, size: 30,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.5),
                            child: Image.network(snapshot.child("img_url").value.toString(), width: 42, height: 42,),
                          )
                      ],
                    ),
                    title: Text("${snapshot.child("type").value == "video" ? "Video" : "3D Model"} №${snapshot.child("img_name").value.toString().split(".")[0]}"),
                    subtitle: Text("User: ${snapshotf.hasData ? snapshotf.data!.snapshot.children.firstWhere((x) => x.child("uid").value == snapshot.child("uid").value).child("username").value: ""}"),
                    // subtitle: Text(snapshot.child("email").value.toString()),
                    onTap: () {
                      _contentActionSheet(snapshot);
                    },
                  ),
                );
                }
                return SizedBox.shrink();
              },
            ),
          ));
        }
    );
    
  }

  final _fbStorage = FBStorage();

  void _contentActionSheet(DataSnapshot snapshot) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("Content", style: TextStyle(fontSize: 16),),
        content: Text("${snapshot.child("type").value == "video" ? "Video" : "3D Model"} №${snapshot.child("img_name").value.toString().split(".")[0]}"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              FirebaseDB().firebaseRTDB.ref("content/${snapshot.key}").remove().then((value){
                _fbStorage.deleteFileFromStorage(snapshot.child("img_url").value.toString());
                _fbStorage.deleteFileFromStorage(snapshot.child("file_url").value.toString());
                if(snapshot.child("texture_url").value != "")
                  _fbStorage.deleteFileFromStorage(snapshot.child("texture_url").value.toString());

                Navigator.pop(context);
              });
            },
            child: 
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    'Remove this content',
                    style: TextStyle(color: Colors.red, fontSize: 16)
                  ),)
                ],
              )
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.grey)),
          )
        ],
        
      ),
    );
  }

  Widget _search(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: CupertinoSearchTextField(
        padding: EdgeInsets.fromLTRB(5.5, 12, 5.5, 12),
        prefixInsets: EdgeInsets.all(10),
        suffixInsets: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(25),
        controller: searchTextController,
        placeholder: 'Search',
        onChanged: (value) {
          setState(() {
            _query = value;
          });
        },
        // onSubmitted: (value) {
        //   print(value);
        // },
      ),
    );
  }
}