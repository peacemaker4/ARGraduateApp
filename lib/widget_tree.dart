import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/home.dart';
import 'package:flutter_ar_app/pages/login.dart';
import 'package:flutter_ar_app/pages/nav.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return NavPage();
        }
        else{
          return LoginPage();
        }
      },
    );
  }

}