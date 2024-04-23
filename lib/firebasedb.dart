import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/models/DBUser.dart';

class FirebaseDB{
  final firebaseRTDB = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://argraduateapp-default-rtdb.asia-southeast1.firebasedatabase.app/');

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Object? dbUser;

  // Future<void> getUser() async {
  //   final ref = FirebaseDB().firebaseRTDB.ref();
  //   // final snapshot = await ref.child('users/${currentUser?.uid}').get();
  //   // if (snapshot.exists) {
  //   //     return snapshot.value;
  //   // } else {
  //   //     print('No data available.');
  //   // }
  //   DatabaseReference dbRef = firebaseRTDB.ref('users/${currentUser?.uid}');
  //   dbRef.onValue.listen((DatabaseEvent event) {
  //     final data = event.snapshot.value;
  //     debugPrint(data.toString());
  //     dbUser = data;
  //   });
  // }

    
}