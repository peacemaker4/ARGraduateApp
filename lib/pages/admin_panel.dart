import 'dart:convert';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/pages/ar_content_add_form.dart';
import 'package:flutter_ar_app/pages/content_page.dart';
import 'package:flutter_ar_app/pages/groups_page.dart';
import 'package:flutter_ar_app/pages/profile_edit.dart';
import 'package:flutter_ar_app/pages/role_request_modal.dart';
import 'package:flutter_ar_app/pages/users_page.dart';
import 'package:intl/intl.dart';

import '../values/app_colors.dart';

final User? user = Auth().currentUser;

var _dbuser;

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> with TickerProviderStateMixin {

  late final AnimationController controller;

  late final Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller = BottomSheet.createAnimationController(this);
    AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  Widget _usersInfo(){
    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('users').once(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var count = snapshot.data!.snapshot.children.length;
          var dt_now = DateTime.now();

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  width: 2, 
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Row(
                children: [
                  SizedBox(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Users",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                          Text(
                            "${DateFormat('dd MMMM  kk:mm').format(dt_now)}",
                            style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white70),
                          ),
                          
                        ],
                      )
                    )
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${count}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        )
                      ),
                      SizedBox(width: 7,),
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),) ;
        }
        else{
          return CircularProgressIndicator();
        }
      });
  }

  Widget _groupsInfo(){
    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('groups').once(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var count = snapshot.data!.snapshot.children.length;
          var dt_now = DateTime.now();

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupsPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  width: 2, 
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Row(
                children: [
                  SizedBox(
                    child: Icon(
                      Icons.groups,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Groups",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                          Text(
                            "${DateFormat('dd MMMM  kk:mm').format(dt_now)}",
                            style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white70),
                          ),
                          
                        ],
                      )
                    )
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${count}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        )
                      ),
                      SizedBox(width: 7,),
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),) ;
        }
        else{
          return CircularProgressIndicator();
        }
      });
  }

  Widget _contentInfo(){
    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('content').once(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var count = snapshot.data!.snapshot.children.length;
          var dt_now = DateTime.now();

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContentPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                border: Border.all(
                  width: 2, 
                  color: Colors.deepOrange,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Row(
                children: [
                  SizedBox(
                    child: Icon(
                      Icons.perm_media_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Available content",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                          Text(
                            "${DateFormat('dd MMMM  kk:mm').format(dt_now)}",
                            style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white70),
                          ),
                          
                        ],
                      )
                    )
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${count}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        )
                      ),
                      SizedBox(width: 7,),
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),);
        }
        else{
          return CircularProgressIndicator();
        }
      });
  }

  Widget _header(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
      child: Text("Admin panel", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),),
    );
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(child: 
      Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Color.fromARGB(255, 57, 123, 255),
        shadowColor: Color.fromARGB(84, 0, 0, 0),
        // title: const Text('Admin', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500)), 
        ),
        backgroundColor: Color.fromARGB(255, 244, 242, 244),
        body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: [
            _header(),
            _usersInfo(),
            SizedBox(height: 15,),
            _groupsInfo(),
            SizedBox(height: 15,),
            _contentInfo(),
          ],
        ),
      )), 
      onRefresh:() async {
        setState(() {
          
        });
      },
    );
  }

  Widget _addARContentButton(){
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ARContentAddFormPage()),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(15), 
        child: Wrap(
          spacing: 7,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Add user content",
              style: TextStyle(
                color: AppColors.primaryColor,
              )
            ),
            Icon(
              Icons.add_photo_alternate,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ],
        )
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(20.0),  
          ),
        ),

      ),
      
    );
  }

}