import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../auth.dart';
import '../firebasedb.dart';
import 'dart:io' as io;

import '../values/app_colors.dart';

class Videos extends StatefulWidget {
  Videos({Key? key}) : super(key: key);
  
  @override
  State<Videos> createState() => _VideosState();

}

class _VideosState extends State<Videos> {

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
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No videos available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.videocam_off_rounded, color: Colors.grey,)],) 
              ),
            );
          }

          var content = snapshot.data?.snapshot.children.where((x) => x.child("type").value == "video").toList().reversed;
          if(!content!.isEmpty){
            return Scaffold(
              body: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                children: content!.map(_createGridTileWidget).toList(),
              ),
            );
          }
          
        }
        return Scaffold(
          body: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No videos available", style: TextStyle(color: Colors.grey),), SizedBox(width: 3,) , Icon(Icons.videocam_off_rounded, color: Colors.grey,)],) 
          ),
        );
      });
  }

  Widget _createGridTileWidget(DataSnapshot data) { 
    
    var vid_url = data.child("file_url").value.toString();
    var vid_name = data.child("file_name").value.toString();

    var thumbnail = getThumbnailFromVideoUrl(vid_url);

    var vid_controller = VideoPlayerController.networkUrl(Uri.parse(
      vid_url))
    ..initialize().then((_) {
      
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    });

    return FutureBuilder(
      future: thumbnail,
      builder:(context, snapshot) {
        if(snapshot.hasData){
          // _saveLocally(vid_url, vid_name);
          return Builder(
            builder: (context) => Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [ GestureDetector(
              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: RawMaterialButton(
                onPressed: () {
                  showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 5), child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: vid_controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: vid_controller.value.aspectRatio,
                                  child: VideoPlayer(vid_controller),
                                )
                              : Container(),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                            onPressed: () {
                              setState(() {
                                vid_controller.value.isPlaying
                                    ? vid_controller.pause()
                                    : vid_controller.play();
                              });
                            },
                            child: Icon(
                              vid_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: AppColors.primaryColor,
                            ),
                          ),
                      ],
                    ),
                  )
                ),) ;
                },
                elevation: 2.0,
                fillColor: Color(0xFFF5F6F9),
                child: Icon(Icons.play_arrow, color: AppColors.primaryColor,),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
            )),
            ]),
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
        
      },);
  }

  Future<Uint8List?> getThumbnailFromVideoUrl(var vid_url) async {
    return await VideoThumbnail.thumbnailData(
      video: vid_url,
      imageFormat: ImageFormat.PNG,
      // maxWidth: 128, 
      quality: 25,
    );
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