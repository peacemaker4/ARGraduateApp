import 'dart:typed_data';

import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../auth.dart';
import '../firebasedb.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController searchTextController = TextEditingController();


  Widget _bouncingButton(){
    return BouncingButton(
      upperBound: 0.1,
      duration: Duration(milliseconds: 100),
      child: Container(
        height: 45,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromARGB(255, 57, 123, 255),
        ),
        child: const Center(
          child: Text(
            'Welcome home',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )),
        onPressed: () {
          
        }
    );
  }

  Widget _header(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
      // child: Text("Home page", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
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

  Widget _gallery(){
    var ft = FirebaseDB().firebaseRTDB.ref('content/${Auth().currentUser?.uid}/').once();

    return FutureBuilder(
      future: ft, 
      builder: (context, snapshot){
        if(snapshot.hasData){
          if(snapshot.data!.snapshot.children.isEmpty){
            return Scaffold(
              body: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No images available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.image_not_supported, color: Colors.grey,)],) 
              ),
            );
          }

          var content = snapshot.data?.snapshot.children.toList().reversed;

          _imageProviders = content!.map(_imageProviderGet).toList();

          if(content != null){
            return Scaffold(
              body: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                children: content!.map(_createGridTileWidget).toList(),
              ),
            );
          }
          
        }
        List<String> emptyList = [''];
        return Scaffold(
              body: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                children: emptyList!.map(_loadingGridTileWidget).toList(),
              ),
            );
      });
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
    var img_name = data.child("img_name").value.toString();

    // _saveLocally(img_url, img_name);
    
    var image_file = getFileFromImageUrl(img_url);

    return FutureBuilder(
      future: image_file,
      builder:(context, snapshot) {
        if(snapshot.hasData){
          return Builder(
            builder: (context) => Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final imageProvider = Image.memory(snapshot.data!).image;
                            showImageViewer(context, imageProvider, useSafeArea: true, immersive: false,
                            backgroundColor: Colors.transparent);
                          },
                          child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                        ),
                        
                      ]
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

  Future<Uint8List?> getFileFromImageUrl(var img_url) async {
    return (await NetworkAssetBundle(Uri.parse(img_url))
            .load(img_url))
            .buffer
            .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    requestPermission();
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 242, 244),
      body: _gallery(),
      // Padding(
      //   padding: const EdgeInsets.all(12),
      //   child: Column(
      //     children: [
      //       _search(),
      //       _header(),
            
      //     ]
      //   )
      // )
    );
  }

  Future<void> requestPermission() async {
    await Permission.storage.request();
  }

}