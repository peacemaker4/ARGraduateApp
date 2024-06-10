import 'dart:convert';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/models/Group.dart';
import 'package:flutter_ar_app/pages/ar_content_add_form.dart';
import 'package:flutter_ar_app/pages/content_page.dart';
import 'package:flutter_ar_app/pages/groups_page.dart';
import 'package:flutter_ar_app/pages/profile_edit.dart';
import 'package:flutter_ar_app/pages/role_request_modal.dart';
import 'package:flutter_ar_app/pages/users_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../values/app_colors.dart';
import 'group_members_page.dart';

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
              padding: EdgeInsets.all(25),
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
                      size: 28,
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
                          fontSize: 22
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
              padding: EdgeInsets.all(25),
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
                      size: 28,

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
                          fontSize: 22
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
              padding: EdgeInsets.all(25),
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
                      size: 28,
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
                          fontSize: 22
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
        body: panelHeader()), 
      onRefresh:() async {
        setState(() {
          
        });
      },
    );
  }

  Widget panelHeader() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white), 
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            children: [
              _header(),
              _usersInfo(),
              SizedBox(height: 15,),
              _groupsInfo(),
              SizedBox(height: 15,),
              _contentInfo(),
              SizedBox(height: 25,),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Latest updates",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 84, 84, 84)
                    ),
                  )
                ),
              ),
              Card(
                child: Container(
                  height: 251,
                  child: Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Column(children: [
                      latestUser(),
                      latestGroup(),
                      latestContent(),
                    ],))
                ),
              )
              
              
            ],
          ),
        )
      );
  }

  Widget latestUser(){
    var ft = FirebaseDB().firebaseRTDB.ref('users').once();
    return FutureBuilder(
      future: ft, 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var user = snapshot.data!.snapshot.children.last;

          return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.account_box, size: 30,),
                ],
              ),
              title: Text(user.child("username").value.toString()),
              subtitle: Text(user.child("email").value.toString()),
              onTap: () {
                
              },
            ),
          );
        }
        return SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: SizedBox(
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.black
                ),
              ),
            ),
          ),
        ); 
      }
    );
  }

  Widget latestGroup(){
    var ft = FirebaseDB().firebaseRTDB.ref('groups').once();
    return FutureBuilder(
      future: ft, 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var group = snapshot.data!.snapshot.children.last;

          return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.groups, size: 30,),
                ],
              ),
              title: Text("${group.child("group_name").value.toString()}"),
              subtitle: Text("${group.child("institution").value.toString()}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupMembersPage(group:
                      Group(
                        id: group.key.toString(), 
                        group_name: group.child("group_name").value.toString(),
                        institution: group.child("institution").value.toString(),
                      )
                    )
                  ),
                );
              },
            ),
          );
        }
        return SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: SizedBox(
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.black
                ),
              ),
            ),
          ),
        ); 
      }
    );
  }

  Widget latestContent(){
    var ft = FirebaseDB().firebaseRTDB.ref('content').once();
    return FutureBuilder(
      future: ft, 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var content = snapshot.data!.snapshot.children.last;

          return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.image, size: 30,),
                    
                ],
              ),
              title: Text("${content.child("type").value == "video" ? "Video" : "3D Model"} №${content.child("img_name").value.toString().split(".")[0]}"),
              // subtitle: Text("User: ${snapshotf.hasData ? snapshotf.data!.snapshot.children.firstWhere((x) => x.child("uid").value == snapshot.child("uid").value).child("username").value: ""}"),
              subtitle: Text("File type: ${content.child("file_name").value.toString().split(".")[1]}"),
              
            ),
          );
        }
        return SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: SizedBox(
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.black
                ),
              ),
            ),
          ),
        ); 
      }
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