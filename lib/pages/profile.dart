import 'package:bouncing_button/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ar_app/auth.dart';

final User? user = Auth().currentUser;

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
    return const Text("Firebase Auth");
  }

  Widget _userUid(){
    return Text(user?.email ?? "User email");
  }

  Widget _signOutButton(){
    return ElevatedButton(
      onPressed: Auth().signOut,
      child: const Text("Sign Out"),
    );
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(),
            _userUid(),
            _bouncingButton(),
            _signOutButton(),
          ]
        )
      )
    );
  }

}