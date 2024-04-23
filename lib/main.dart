import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/pages/unityinit.dart';
import 'package:flutter_ar_app/widget_tree.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDB().firebaseRTDB.setPersistenceEnabled(true);
  FirebaseDB().firebaseRTDB.ref('users').keepSynced(true);

  runApp(const MaterialApp(
    home: WidgetTree(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}