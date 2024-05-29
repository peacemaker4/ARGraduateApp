import 'dart:math';
import 'dart:typed_data';

import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ar_app/pages/group_members_page_users.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../auth.dart';
import '../firebasedb.dart';
import '../models/Group.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController searchTextController = TextEditingController();


  Widget _header(var group_id){
    if(group_id != ""){
      return FutureBuilder(
        future: FirebaseDB().firebaseRTDB.ref('groups/${group_id}').once(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data = snapshot.data!.snapshot.value as Map;
            return Container(child: 
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 15, 0, 15), 
                child: 
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: SizedBox(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white
                            ),
                            child:
                              Padding(padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text("${data["group_name"]} ${data["institution"]}", style: TextStyle(fontFamily: "Montserrat", fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.primaryColor),),)
                             
                          ),
                        ),
                      ),)
              )
            ],) ,
            decoration: BoxDecoration(color: Color.fromARGB(255, 244, 242, 244),),
            ) ;
          }
          return _header_default();
        }
      );
    }

    return _header_default();
  }

  Widget _group_members(var group_id){
    if(group_id != ""){
      return FutureBuilder(
        future: FirebaseDB().firebaseRTDB.ref('groups/${group_id}').once(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data = snapshot.data!.snapshot.value as Map;
            return GroupMembersPageUsers(appbar_show: false, group: Group(
                              id: group_id, 
                              group_name: data["group_name"], 
                            ));
          }
          return SizedBox.shrink();
        }
      );
    }
    return Scaffold(
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No group set", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.group_off, color: Colors.grey,)],) 
      ),
    );
  }

  Widget _search(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: CupertinoSearchTextField(
        padding: EdgeInsets.fromLTRB(5.5, 12, 5.5, 12),
        prefixInsets: EdgeInsets.all(10),
        suffixInsets: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(25),
        controller: searchTextController,
        placeholder: 'Search',
        onChanged: (value) {
          print(value);
        },
        onSubmitted: (value) {
          print(value);
        },
      ),
    );
  }

  late List<ImageProvider> _imageProviders;

  GridView view =GridView.count(crossAxisCount: 2, children: [],);


  Widget _gallery(var group){

    var ft = FirebaseDB().firebaseRTDB.ref('users').once();

    var ft2 = FirebaseDB().firebaseRTDB.ref('content').once();
    
    var count = 0;

    if(group != ""){
      return FutureBuilder(
        future: ft, 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Scaffold(
                body: FutureBuilder(future: ft2, 
                  builder: (context, snapshot2){
                    if(snapshot2.hasData){
                      var list_content =  List<DataSnapshot>.empty(growable: true);
                      for(var i in snapshot2.data!.snapshot.children){
                        var match = snapshot.data!.snapshot.children.where((x) => x.child("group").value == group && x.child("uid").value == i.child("uid").value.toString());
                        if(match.length > 0){
                          list_content.add(i);
                        }
                      }
                      if(list_content.length > 0){ 
                        return RefreshIndicator(
                          onRefresh:() async {
                            setState(() {
                              
                            });
                          },
                          child: Scaffold(
                                  body: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.9,
                                    children: list_content!.map(_createGridTileWidget).toList(),
                                  ),
                                )
                          );
                      }
                    }
                    return Scaffold(
                      body: Center(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No images available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
                      ),
                    );

                  }
                )
                

                  // var match = snapshot.data!.snapshot.children.where((x) => x.child("group").value == group && x.child("uid").value == snapshot2.child("uid").value.toString());
                  // if(match.length > 0){
                  //   return Container(height: 200, width: 300, child: _createGridTileWidget(snapshot2));
                    // return Card(
                    //   child: ListTile(
                    //     leading: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: <Widget>[
                    //           Icon(Icons.account_box, size: 30,),
                    //       ],
                    //     ),
                    //     title: Text(snapshot2.child("uid").value.toString()),
                    //     subtitle: Text(snapshot2.child("img_name").value.toString()),
                    //     onTap: () {
                          
                    //     },
                    //   ),
                    // );
                  // }
                  
                // },
              // ),
            );
          }
          return Scaffold(
            body: Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No images available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
            ),
          );
        }
      );
    }
    return Scaffold(
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No images available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
      ),
    );

    // return FutureBuilder(
    //   future: ft, 
    //   builder: (context, snapshot){
    //     if(snapshot.hasData){

    //       ft2.then((content){
    //         for(var c in content.snapshot.children){
    //           var group_members = snapshot.data!.snapshot.children.where((x) => x.child("group").value == group && x.child("uid").value == c.key);
    //           list_content.addAll(group_members);
    //         }
    //         if(content != null){ 
    //             return RefreshIndicator(
    //               onRefresh:() async {
    //                 setState(() {
                      
    //                 });
    //               },
    //               child: Scaffold(
    //                       body: GridView.count(
    //                         crossAxisCount: 2,
    //                         childAspectRatio: 0.9,
    //                         children: list_content!.map(_createGridTileWidget).toList(),
    //                       ),
    //                     )
    //               );
    //           }

    //       });
    //     }
    //     List<String> emptyList = [''];
    //     return Scaffold(
    //           body: Center(
    //             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Loading", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
    //           ),
    //         );
    //   }
    // );

    // return FutureBuilder(
    //   future: ft, 
    //   builder: (context, snapshot){
    //     if(snapshot.hasData){

    //       var group_members = snapshot.data!.snapshot.children.where((x) => x.child("group").value == group);

    //       if(snapshot.data!.snapshot.children.isEmpty){
    //         return Scaffold(
    //           body: Center(
    //             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No images available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
    //           ),
    //         );
    //       }

    //       var content = snapshot.data?.snapshot.children.toList();

    //       _imageProviders = content!.map(_imageProviderGet).toList();

    //       if(content != null){ 
    //         return RefreshIndicator(
    //           onRefresh:() async {
    //             setState(() {
                  
    //             });
    //           },
    //           child: Scaffold(
    //                   body: GridView.count(
    //                     crossAxisCount: 2,
    //                     childAspectRatio: 0.9,
    //                     children: content!.map(_createGridTileWidget).toList(),
    //                   ),
    //                 )
    //           );
    //       }
    //     }
        List<String> emptyList = [''];
        return Scaffold(
              body: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Loading", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
              ),
            );
      // });
  }

  Widget _loadingGridTileWidget(String data) => Builder(
    builder: (context) => GestureDetector(
      child: SizedBox(
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
            ),
    ),
  );

  ImageProvider _imageProviderGet(DataSnapshot data){
    return Image.network(data.child("img_url").value.toString()).image;
  }
  Widget _createGridTileWidget(DataSnapshot data) {
    var img_url = data.child("img_url").value.toString();
    if (img_url != ""){
      var image_file = getFileFromImageUrl(img_url);

      return FutureBuilder(
        future: image_file,
        builder:(context, snapshot) {
          if(snapshot.hasData){
            return Builder(builder: (context) => 
              Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5), 
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final imageProvider = Image.memory(snapshot.data!).image;
                        showImageViewer(context, imageProvider, useSafeArea: true, immersive: false,
                        backgroundColor: Colors.transparent);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(snapshot.data!, fit: BoxFit.cover)
                      ),
                    ),
                  ]
                ),
              ),
            );
          }
          return SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5), 
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                          child: const DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
          ),
        );
        }
      );
    }
    return SizedBox.shrink();

  } 

  Future<Uint8List?> getFileFromImageUrl(var img_url) async {
    return (await NetworkAssetBundle(Uri.parse(img_url))
            .load(img_url))
            .buffer
            .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    requestPermission();
    var ft = FirebaseDB().firebaseRTDB.ref('content/${Auth().currentUser?.uid}/').once();

    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('users/${Auth().currentUser?.uid}').once(), 
      builder: (context, snapshot){
        var data = null;
        if(snapshot.hasData){
          data = snapshot.data!.snapshot.value as Map;
          return DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _header(data["group"]),
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: Color.fromARGB(187, 57, 123, 255),
                  indicatorWeight: 2,
                  indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  indicatorColor: AppColors.primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      icon: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          
                        Icon(
                          Icons.grid_view,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 7,),
                        Text("Yearbook"),
                        SizedBox(width: 7,),
                      ],) ,
                    ),
                    Tab(
                      icon: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                        Icon(
                          Icons.groups,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 7,),
                        Text("Group"),
                        SizedBox(width: 7,),
                      ],) ,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _gallery(data["group"]),
                    _group_members(data["group"]),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      }
      return DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _header_default(),
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
                  unselectedLabelColor: Color.fromARGB(187, 57, 123, 255),
                  indicatorWeight: 2,
                  indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  indicatorColor: AppColors.primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      icon: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          
                        Icon(
                          Icons.grid_view,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 7,),
                        Text("Yearbook"),
                        SizedBox(width: 7,),
                      ],) ,
                    ),
                    Tab(
                      icon: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                        Icon(
                          Icons.groups,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 7,),
                        Text("Group"),
                        SizedBox(width: 7,),
                      ],) ,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Text(""),
                    Text(""),
                    
                    // GroupMembersPageUsers()
                    //ModelsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
  );
        
    
  }

  Widget _header_default(){
    return Center(child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 20, 0, 20), 
                      child: Text("Group", style: TextStyle(fontFamily: "Montserrat", fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.primaryColor),),
                    ),);
  }

  Future<void> requestPermission() async {
    await Permission.storage.request();
  }

}