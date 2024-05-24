import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../auth.dart';
import '../firebasedb.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io' as io;

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;
 
  @override
  Widget build(BuildContext context) {
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

          if(content != null){
            return Scaffold(
              body: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                children: content!.map(_createGridTileWidget).toList(),
              ),
            );
          }
          
        }
        List<String> emptyList = [''];
        return Scaffold(
              body: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                children: emptyList!.map(_loadingGridTileWidget).toList(),
              ),
            );
      });
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
            builder: (context) => GestureDetector(
              onLongPress: () {
                // _popupDialog = _createPopupDialog(data);
                // Overlay.of(context).insert(_popupDialog);
              },
              onLongPressEnd: (details) => _popupDialog?.remove(),
              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
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

  void _saveLocally(var file_url, var file_name) async{
    var dir_path = "/storage/emulated/0/Pictures/ARApp";

    var dir_exists = await io.Directory(dir_path).exists();
    if(!dir_exists){
      Directory dir = Directory(dir_path);
      dir.create(recursive: true);
    }

    var file_exists = await io.File("$dir_path/$file_name").exists();
    
    if(!file_exists){
      HttpClient httpClient = new HttpClient();
      File file;
      String filePath = '';
      String myUrl = '';

      try {
        myUrl = file_url;
        var request = await httpClient.getUrl(Uri.parse(myUrl));
        var response = await request.close();
        if(response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          filePath = '$dir_path/$file_name';
          file = File(filePath);
          await file.writeAsBytes(bytes);
        }
        else
          filePath = 'Error code: '+response.statusCode.toString();
      }
      catch(ex){
        filePath = 'Can not fetch url';
      }
    }

  }

  //save dialog
  // final scaffoldMessenger = ScaffoldMessenger.of(context);
  //   late String message;

  //   // Directory dir = Directory('"/storage/emulated/0/Pictures/ARApp"');
  //   final http.Response response = await http.get(Uri.parse(url));

  //     // Get temporary directory
  //     final dir = await getTemporaryDirectory();

  //     // Create an image name
  //     var filename = '${dir.path}/SaveImage${5}.png';

  //     // Save to filesystem
  //     final file = File(filename);
  //     await file.writeAsBytes(response.bodyBytes);

  //     // Ask the user to save it
  //     final params = SaveFileDialogParams(sourceFilePath: file.path);
  //     final finalPath = await FlutterFileDialog.saveFile(params: params);

  //     if (finalPath != null) {
  //       message = 'Image saved to disk';
  //     }

  Widget _loadingGridTileWidget(String data) => Builder(
        builder: (context) => GestureDetector(
          onLongPress: () {
            // _popupDialog = _createPopupDialog(data);
            // Overlay.of(context).insert(_popupDialog);
          },
          onLongPressEnd: (details) => _popupDialog?.remove(),
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

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://images.immediate.co.uk/production/volatile/sites/3/2021/07/intro-1585140261-2b040b9.jpg?quality=90&resize=620,414'),
        ),
        title: Text(
          'john.doe',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ));

  Widget _createActionBar() => Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            Icon(
              Icons.chat_bubble_outline_outlined,
              color: Colors.black,
            ),
            Icon(
              Icons.send,
              color: Colors.black,
            ),
          ],
        ),
      );

  Widget _createPopupContent(String url) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(),
              Image.network(url, fit: BoxFit.fitWidth),
              _createActionBar(),
            ],
          ),
        ),
      );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}