import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/utils/widgets/custom_loading_widget.dart';
import 'package:flutter_ar_app/widget_tree.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDB().firebaseRTDB.setPersistenceEnabled(true);
  FirebaseDB().firebaseRTDB.ref('users').keepSynced(true);
  FirebaseDB().firebaseRTDB.ref('role_requests').keepSynced(true);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top]
  );

  runApp(MaterialApp(
    home: WidgetTree(),
    debugShowCheckedModeBanner: false,
    navigatorObservers: [FlutterSmartDialog.observer],
    builder: FlutterSmartDialog.init(
      loadingBuilder: (String msg) => CustomLoadingWidget(),
    ),
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