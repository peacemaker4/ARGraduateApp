import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/group_members_page_users.dart';
import 'package:flutter_ar_app/pages/models_list.dart';
import 'package:flutter_ar_app/pages/profile_edit.dart';
import 'package:flutter_ar_app/pages/videos.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../auth.dart';
import '../firebasedb.dart';
import '../models/DBUser.dart';
import '../models/Group.dart';
import 'admin_panel.dart';
import 'gallery.dart';


class ProfileUserPage extends StatefulWidget {

  String uid;

  ProfileUserPage({super.key, required this.uid});

  @override
  _ProfileUserPageState createState() => _ProfileUserPageState(uid);
}

class _ProfileUserPageState extends State<ProfileUserPage> {

  String uid;

  _ProfileUserPageState(this.uid){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User profile"), centerTitle: true, backgroundColor: Colors.white, foregroundColor: AppColors.primaryColor,),
      body: FutureBuilder(
        future: FirebaseDB().firebaseRTDB.ref('users/${uid}').once(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data = snapshot.data?.snapshot.value as Map;
          
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          profileHeader(snapshot),
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: <Widget>[
                    Material(
                      color: Colors.white,
                      child: TabBar(
                        labelColor: AppColors.primaryColor,
                        unselectedLabelColor: Colors.grey[400],
                        indicatorWeight: 3,
                        indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        indicatorColor: AppColors.primaryColor,
                        tabs: [
                          Tab(
                            icon: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                              // SizedBox(width: 5,),
                              // Text("Memories"),
                              // SizedBox(width: 5,),
                              Icon(
                                Icons.grid_on,
                                color: AppColors.primaryColor,
                              ),
                            ],) ,
                          ),
                          Tab(
                            icon: Icon(
                              Icons.video_camera_back,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          // Tab(
                          //   icon: Icon(
                          //     Icons.file_present_sharp,
                          //     color: AppColors.primaryColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Gallery(uid: data["uid"]),
                          Videos(uid: data["uid"]),
                          //ModelsList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SizedBox.shrink();

          
        }
      )
    );
  }
  
  Widget profileHeader(var snapshot) {
    if(snapshot.hasData){
      var data = snapshot.data!.snapshot.value as Map;
      // var user = DBUser.fromJson(jsonDecode(data.toString()));
      var img_url = data['img_url'];
      
      var group_name = "";

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  img_url != ""
                  ?
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                        NetworkImage(img_url),
                    )
                  :
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: 
                        AssetImage('assets/images/default_avatar.png'),
                    )
                  ,
                  
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '${data['username']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              // Text(
              //   '${user?.email}',
              //   style: TextStyle(
              //     letterSpacing: 0.4,
              //   ),
              // ),
              // SizedBox(
              //   height: 4,
              // ),
              data["group"] != "" ? 
              _groupName(data["group"])
                : Text(
                '${data["email"]}',
                style: TextStyle(
                  letterSpacing: 0.4,
                ),
              )
              ,

              Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
        ],
        ),
              
            ],
          ),
        ),
      );
    }
    else{
        return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child:
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Color(0xff74EDED),
                          backgroundImage: 
                            AssetImage('assets/images/default_avatar.png'),
                        )
                  )
                  ,
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child:
                Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.4,
                  ),
                )
              ),
              SizedBox(
                height: 4,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child:
                Text(
                  'Email',
                  style: TextStyle(
                    letterSpacing: 0.4,
                  ),
                )
              ),
              SizedBox(
                height: 20,
              ),
              Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
        ],
        ),
              
            ],
          ),
        ),
      );
    }
  }

  Widget _groupName(var group_id){
    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('groups/${group_id}').once(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var data = snapshot.data!.snapshot.value as Map;
          return Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            FilterChip(
                    backgroundColor: AppColors.primaryColor,
                    label: Text('${data["institution"]}', 
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.bold
                    )),
                    onSelected: (value) {
                      
                    },
                  ),
                  SizedBox(width: 5,),
                  FilterChip(
                    backgroundColor: AppColors.primaryColor,
                    label: Text('${data["group_name"]}', 
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.bold
                    )),
                    onSelected: (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GroupMembersPageUsers(group: Group(
                              id: group_id, 
                              group_name: data["group_name"], 
                            ))),
                      );
                    },
                  ),
          ],) ;
        }
        return Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            FilterChip(
                    backgroundColor: AppColors.primaryColor,
                    label: Text('Info', 
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.bold
                    )),
                    onSelected: (value) {
                      
                    },
                  ),
                  SizedBox(width: 5,),
                  FilterChip(
                    backgroundColor: AppColors.primaryColor,
                    label: Text('Group', 
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.bold
                    )),
                    onSelected: (value) {
                      
                    },
                  ),
          ],) ;
      }
    );

  }

}