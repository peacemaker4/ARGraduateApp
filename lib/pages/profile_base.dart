import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/models_list.dart';
import 'package:flutter_ar_app/pages/profile_edit.dart';
import 'package:flutter_ar_app/pages/videos.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../auth.dart';
import '../firebasedb.dart';
import '../models/DBUser.dart';
import 'admin_panel.dart';
import 'gallery.dart';

final User? user = Auth().currentUser;

var _dbuser;

class ProfileBasePage extends StatefulWidget {
  @override
  _ProfileBasePageState createState() => _ProfileBasePageState();
}

class _ProfileBasePageState extends State<ProfileBasePage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:() async {
        setState(() {
          
        });
      },
      child: Scaffold(
      // backgroundColor: Color.fromARGB(255, 244, 242, 244),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    profileHeader(),
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
                      icon: Icon(
                        Icons.grid_on_rounded,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.video_camera_back,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.file_present_sharp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Gallery(),
                    Videos(),
                    ModelsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _header(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
      child: Text("Profile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),),
    );
  }
  
  Widget profileHeader() {
    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('users/${Auth().currentUser?.uid}').once(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          var data = snapshot.data!.snapshot.value as Map;
          // var user = DBUser.fromJson(jsonDecode(data.toString()));
          var img_url = data['img_url'];
          
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
                      // Row(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Text(
                      //           "10",
                      //           style: TextStyle(
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w700,
                      //           ),
                      //         ),
                      //         Text(
                      //           "Posts",
                      //           style: TextStyle(
                      //             fontSize: 15,
                      //             letterSpacing: 0.4,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     SizedBox(
                      //       width: 30,
                      //     ),
                      //     Column(
                      //       children: [
                      //         Text(
                      //           "0",
                      //           style: TextStyle(
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w700,
                      //           ),
                      //         ),
                      //         Text(
                      //           "Followers",
                      //           style: TextStyle(
                      //             letterSpacing: 0.4,
                      //             fontSize: 15,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     SizedBox(
                      //       width: 30,
                      //     ),
                      //     Column(
                      //       children: [
                      //         Text(
                      //           "0",
                      //           style: TextStyle(
                      //             letterSpacing: 0.4,
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w700,
                      //           ),
                      //         ),
                      //         Text(
                      //           "Following",
                      //           style: TextStyle(
                      //             letterSpacing: 0.4,
                      //             fontSize: 15,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     SizedBox(
                      //       width: 15,
                      //     ),
                      //   ],
                      // )
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
                  Text(
                    '${user?.email}',
                    style: TextStyle(
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _editProfileButton(data),
              _adminPanelButton(data['role']),
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
              _loadingButton(),
            ],
            ),
                  
                ],
              ),
            ),
          );
        }
      }
    );
  }

  Widget _editProfileButton(var data){
    return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileEditPage(dbuser:
                  DBUser(
                    uid: user?.uid, 
                    email: user?.email, 
                    username: data['username'], 
                    role: data['role'], 
                    img_url: data['img_url']
                  )
                )
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(15), 
            child: Wrap(
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  )
                ),
                Icon(
                  Icons.edit,
                  size: 15,
                  color: AppColors.primaryColor,
                ),
              ],
            )
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                side: BorderSide(color: AppColors.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(10.0),  
              ),
            ),

          ),
                
        );
  }

  Widget _adminPanelButton(String user_role){
      if(user_role == "admin"){
        return Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPanelPage()),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(15), 
            child: Wrap(
              spacing: 7,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Admin panel",
                  style: TextStyle(
                    color: Colors.orange,
                  )
                ),
                Icon(
                  Icons.admin_panel_settings,
                  size: 15,
                  color: Colors.orange,
                ),
              ],
            )
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                side: BorderSide(color: Colors.orange, width: 1),
                borderRadius: BorderRadius.circular(10.0),  
              ),
            ),

          ),
        )
        );
      }
      return SizedBox.shrink();
    }

    Widget _loadingButton(){
    return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child:
           ElevatedButton(
          onPressed: () {
          },
          child: Padding(
            padding: EdgeInsets.all(15), 
            child: Wrap(
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  )
                ),
                Icon(
                  Icons.edit,
                  size: 15,
                  color: AppColors.primaryColor,
                ),
              ],
            )
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                side: BorderSide(color: AppColors.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(10.0),  
              ),
            ),

          ),
                
        ));
  }
}