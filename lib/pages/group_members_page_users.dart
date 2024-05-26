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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Group.dart';

class GroupMembersPageUsers extends StatefulWidget {
  Group group;

  GroupMembersPageUsers({super.key, required this.group});

  @override
  State<GroupMembersPageUsers> createState() => _GroupMembersPageUsersState(group);
}

class _GroupMembersPageUsersState extends State<GroupMembersPageUsers> {

  var db_ref = FirebaseDB().firebaseRTDB.ref('users');

  Group group;

  _GroupMembersPageUsersState(this.group){}

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
            body: FirebaseAnimatedList(
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
                        
                      },
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ));
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