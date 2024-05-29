import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/pages/group_add_form.dart';
import 'package:flutter_ar_app/pages/profile_user.dart';
import 'package:flutter_ar_app/pages/select_user_modal.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Group.dart';

class GroupMembersPageUsers extends StatefulWidget {
  Group group;
  bool appbar_show = true;

  GroupMembersPageUsers({super.key, required this.group, this.appbar_show = true});

  @override
  State<GroupMembersPageUsers> createState() => _GroupMembersPageUsersState(group, appbar_show);
}

class _GroupMembersPageUsersState extends State<GroupMembersPageUsers> {

  var db_ref = FirebaseDB().firebaseRTDB.ref('users');

  Group group;
  bool appbar_show;

  _GroupMembersPageUsersState(this.group, this.appbar_show){}

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
            appBar: appbar_show ? AppBar(title: Text(group.group_name.toString()), centerTitle: true, backgroundColor: Colors.white, foregroundColor: AppColors.primaryColor,) : AppBar(toolbarHeight: 0,),
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

                  var img_url = snapshot.child("img_url").value.toString();

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: ListTile(
                        title: Text(snapshot.child("username").value.toString(), style: TextStyle(color: Color.fromARGB(255, 85, 85, 85)),),
                        onTap: () {
                          if(Auth().currentUser!.uid != snapshot.child("uid").value){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileUserPage(
                                  uid: snapshot.child("uid").value.toString(),
                                )
                              ),
                            );
                          }
                        },
                        leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              img_url != ""
                              ?
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage:
                                    NetworkImage(img_url),
                                )
                              :
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: 
                                    AssetImage('assets/images/default_avatar.png'),
                                )
                              ,
                                //Icon(Icons.account_box, size: 30,),
                            ],
                          ),
                        )
                      )
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