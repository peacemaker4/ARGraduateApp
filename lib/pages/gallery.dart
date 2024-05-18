import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../auth.dart';
import '../firebasedb.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

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
                child: Text("No images available")
              ),
            );
          }

          var content = snapshot.data?.snapshot.children.toList();

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

    _saveLocally(img_url);
    
    return Builder(
      builder: (context) => GestureDetector(
        onLongPress: () {
          // _popupDialog = _createPopupDialog(data);
          // Overlay.of(context).insert(_popupDialog);
        },
        onLongPressEnd: (details) => _popupDialog?.remove(),
        child: Image.network(img_url, fit: BoxFit.cover),
      ),
    );

  } 

  void _saveLocally(var url) async{
    var response = await http.get(Uri.parse(url));
    // Directory? externalStorageDirectory = await getApplicationDocumentsDirectory();
    
    // var save_dir = externalStorageDirectory!.path;
    Directory dir = Directory('"/storage/emulated/0/Pictures/ARApp"');
    var save_dir = dir.path;

    print(path.join(save_dir, path.basename(url)));
    new File(path.join(save_dir, path.basename(url))).create(recursive: true).then((file) async{
      await file.writeAsBytes(response.bodyBytes);
    });
    // await file.writeAsBytes(response.bodyBytes);

    // showDialog(
    //   context:context,
    //   builder: (BuildContext context) => 
    //   AlertDialog(
    //     title: Text("${file.path.toString()}"),
    //     content: Image.file(file)
    //   )
    // );
  }

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