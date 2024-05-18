import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoModal extends StatefulWidget {
  AppInfoModal({super.key});

  @override
  State<AppInfoModal> createState() => _AppInfoModalState();
}

class _AppInfoModalState extends State<AppInfoModal> {

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Container(
        height: 350,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('About', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 119, 119, 119),
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            SizedBox(height: 10,),
            Text('''AR mobile app that allows users to scan graduation photos and view them as videos in 3D, enhancing the way graduates celebrate and remember their experiences
  ''', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontFamily: "Montserrat",),
            ),
            const SizedBox(height: 10,),
            Text('Github: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: "Montserrat",),
            ),
            SignInButton(
              Buttons.gitHub,
              onPressed: () {
                launchUrl(Uri(scheme: 'https', host: 'www.github.com', path: 'peacemaker4/ARGraduateApp'));
              },
              text: "Check app on Github",
              padding: EdgeInsets.fromLTRB(75, 5, 75, 5),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.all(new Radius.circular(22))),
            ),
          ]
        )
      ),
    );
  }
}