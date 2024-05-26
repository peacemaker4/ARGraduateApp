import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersPage extends StatefulWidget {
  UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  var db_ref = FirebaseDB().firebaseRTDB.ref('users');

  TextEditingController searchTextController = TextEditingController();

  var _query = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: _search(), centerTitle: true, backgroundColor: Colors.white, foregroundColor: AppColors.primaryColor, ),
      body: FirebaseAnimatedList(
        query: db_ref,
        itemBuilder: (context, snapshot, animation, index){
          if(snapshot.child("username").value.toString().startsWith(_query) || snapshot.child("email").value.toString().startsWith(_query)){
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