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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupsPage extends StatefulWidget {
  GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {

  var db_ref = FirebaseDB().firebaseRTDB.ref('groups');

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
                tooltip: 'Add group',
                onPressed: (){
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                    ),
                    context: context, 
                    builder: (context) => GroupAddFormPage(),
                  );
                },
                child: const Icon(Icons.group_add, color: Colors.white, size: 24),
              )
            ),
            body: FirebaseAnimatedList(
              query: db_ref,
              itemBuilder: (context, snapshot, animation, index){
                if(snapshot.child("group_name").value.toString().startsWith(_query)){
                  return Card(
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                          Icon(Icons.groups, size: 30,),
                      ],
                    ),
                    title: Text("${snapshot.child("institution").value.toString()} ${snapshot.child("group_name").value.toString()}"),
                    subtitle: Text("Members: ${snapshotf.hasData ? snapshotf.data!.snapshot.children.where((x) => x.child("group").value == "${snapshot.key}").length: "~"}"),
                    // subtitle: Text(snapshot.child("email").value.toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GroupMembersPage(group:
                            Group(
                              id: snapshot.key.toString(), 
                              group_name: snapshot.child("group_name").value.toString(),
                              institution: snapshot.child("institution").value.toString(),
                            )
                          )
                        ),
                      );
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