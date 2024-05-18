import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _firebaseRTDB = FirebaseDB().firebaseRTDB;
  
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    var cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
      var cred_email = value.user!.email!;
      var cred_uid = value.user!.uid;

      DatabaseReference ref = _firebaseRTDB.ref("users/${cred_uid}");
      await ref.set({
        "uid": cred_uid,
        "email": cred_email,
        "username": username,
        "role": "user",
        "img_url": "",
      });
    });
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final sign = await FirebaseAuth.instance.signInWithCredential(credential).then((value) async{
      SmartDialog.dismiss();
      var cred_uid = value.user!.uid;

      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$cred_uid').get();
      if (!snapshot.exists) {
        var cred_email = value.user!.email!;
        var username = value.user!.displayName;
        
        DatabaseReference ref = _firebaseRTDB.ref("users/${cred_uid}");
        await ref.set({
          "uid": cred_uid,
          "email": cred_email,
          "username": username,
          "role": "user"
        });
      }
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}