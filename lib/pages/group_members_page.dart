import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/pages/group_add_form.dart';
import 'package:flutter_ar_app/pages/select_user_modal.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Group.dart';

class GroupMembersPage extends StatefulWidget {
  Group group;

  GroupMembersPage({super.key, required this.group});

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState(group);
}

class _GroupMembersPageState extends State<GroupMembersPage> {

  var db_ref = FirebaseDB().firebaseRTDB.ref('users');

  Group group;

  _GroupMembersPageState(this.group){}

  TextEditingController searchTextController = TextEditingController();

  var _query = "";

  @override
  Widget build(BuildContext context){
    
    return RefreshIndicator(
          onRefresh:() async {
            setState(() {
              
            });
        },
        child: Scaffold(
            appBar: AppBar(title: Text(group.group_name.toString()), centerTitle: true, backgroundColor: Colors.white, foregroundColor: AppColors.primaryColor, ),
            floatingActionButton: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10), child: 
              FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                elevation: 10,
                tooltip: 'Add member',
                onPressed: (){
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                    ),
                    context: context, 
                    builder: (context) => SelectUserModal(),
                  ).then((value) async{
                    if(value != null){
                      var s_user = value as DBUser;

                      DatabaseReference ref = FirebaseDB().firebaseRTDB.ref("users/${s_user.uid}");
                      await ref.set({
                        "uid": s_user.uid,
                        "email": s_user.email,
                        "username": s_user.username,
                        "role": s_user.role,
                        "group": group.id,
                        "img_url": s_user.img_url
                      });
                      
                      setState(() {});
                    }
                  });
                },
                child: const Icon(Icons.person_add, color: Colors.white, size: 24),
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
                if(snapshot.child("group").value.toString() == group.id){
                  return Card(
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            Icon(Icons.account_box, size: 30,),
                        ],
                      ),
                      title: Text(snapshot.child("username").value.toString()),
                      subtitle: Text(snapshot.child("email").value.toString()),
                      onTap: () {
                        _groupMemberActionSheet(snapshot);
                      },
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ));
        }
    

  void _groupMemberActionSheet(var snapshot) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("Group member", style: TextStyle(fontSize: 16),),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              DatabaseReference ref = FirebaseDB().firebaseRTDB.ref("users/${snapshot.child("uid").value}");
              await ref.set({
                "uid": snapshot.child("uid").value,
                "email": snapshot.child("email").value,
                "username": snapshot.child("username").value,
                "role":  snapshot.child("role").value,
                "group": "",
                "img_url": snapshot.child("img_url").value,
              });
              setState(() {});

              Navigator.pop(context);
            },
            child: 
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Remove from current group',
                    style: TextStyle(color: Colors.red, fontSize: 16)
                  ),
                  
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

  // Widget _search(){
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //     child: CupertinoSearchTextField(
  //       padding: EdgeInsets.fromLTRB(5.5, 12, 5.5, 12),
  //       prefixInsets: EdgeInsets.all(10),
  //       suffixInsets: EdgeInsets.all(10),
  //       borderRadius: BorderRadius.circular(25),
  //       controller: searchTextController,
  //       placeholder: 'Search',
  //       onChanged: (value) {
  //         setState(() {
  //           _query = value;
  //         });
  //       },
  //       // onSubmitted: (value) {
  //       //   print(value);
  //       // },
  //     ),
  //   );
  // }
}