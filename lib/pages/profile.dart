import 'dart:convert';

import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';

final User? user = Auth().currentUser;

var _dbuser;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Widget _title(){
    return const Text("Profile");
  }

  Widget _userEmail(){
    return Text(user?.email ?? "User email");
  }

  Widget _userInfo(){
    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('users/${Auth().currentUser?.uid}').once(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var data = snapshot.data!.snapshot.value as Map;
          // var user = DBUser.fromJson(jsonDecode(data.toString()));

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('uid: ${data['uid']}'),
                Text('username: ${data['username']}'),
                Text('role: ${data['role']}'),
              ]
            )
          );
        }
        else{
          return CircularProgressIndicator();
        }
      });
  }

  Widget _bouncingButton(){
    return BouncingButton(
              upperBound: 0.1,
              duration: Duration(milliseconds: 100),
              child: Container(
                height: 45,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Color.fromARGB(255, 57, 123, 255),
                ),
                child: const Center(
                  child: Text(
                    'Click Me!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
                onPressed: (){
                  
                }
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 242, 244),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(),
            _userEmail(),
            _userInfo(),
          ]
        )
      )
    );
  }

}