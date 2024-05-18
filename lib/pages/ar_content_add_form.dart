import 'dart:convert';
import 'dart:typed_data';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/pages/profile_edit.dart';
import 'package:flutter_ar_app/pages/role_request_modal.dart';
import 'package:flutter_ar_app/pages/select_user_modal.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

import '../fb_storage.dart';
import '../utils/image_picker.dart';
import '../values/app_colors.dart';
import 'package:path/path.dart' as path;


final User? user = Auth().currentUser;

var _dbuser;

class ARContentAddFormPage extends StatefulWidget {
  const ARContentAddFormPage({Key? key}) : super(key: key);

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<ARContentAddFormPage> createState() => _ARContentAddFormPageState();
}

class _ARContentAddFormPageState extends State<ARContentAddFormPage> with TickerProviderStateMixin {

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

  var _search_query = "";

  var _curr_user = null;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
            _selectUserButton(),
            _selectedUser(),
            _selectImageButton(),
            _selectedImage(),
            _selectedImagePreview(),
            _selectVideoButton(),
            _selectedVideo(),
            _submitButton(),
          ],
        ),
      )), 
      onRefresh:() async {
        setState(() {
          
        });
      },
    );
  }

  Widget _header(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
      child: Text("Add Content", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),),
    );
  }

  Widget _selectUserButton(){
      return ElevatedButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) => SelectUserModal()).then((value){
            if(value != null){
              var s_user = value as DBUser;
              setState(() {
                _curr_user = s_user;
              });
            }
          });
        }, 
        child: Text("Select user"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),  
            ),
          ),
        ),
      );
  }

  Widget _selectedUser(){
    if(_curr_user != null){
      return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.account_box, color: AppColors.primaryColor, size: 30,),
                ],
              ),
              title: Text(_curr_user.username),
              subtitle: Text(_curr_user.email),
              onTap: () {
                setState(() {
                  _curr_user = null;
                });
              },
            ),
      );
    }
    return SizedBox.shrink();
  }

  Uint8List? _image;
  String? _image_extension;


  void selectImage() async{
    var picked = await pickImage(ImageSource.gallery);
    Uint8List img;
    String? img_extension;

    if(picked != null){
      img = picked[0];
      img_extension = picked[1];

      setState(() {
      _image = img;
      _image_extension = img_extension;
    });
    }
  }
  
  Widget _selectImageButton(){
      return ElevatedButton(
        onPressed: () {
          selectImage();
        }, 
        child: Text("Select image"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),  
            ),
          ),
        ),
      );
  }

  Widget _selectedImage(){
    if(_image != null){
      var img_size_kb = _image!.lengthInBytes/(1024);
      var img_size_mb = _image!.lengthInBytes/(1024*1024);

      return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.image, color: AppColors.primaryColor, size: 30,),
                ],
              ),
              title: Text("Image"),
              subtitle: img_size_mb > 0.5 ? Text("${img_size_mb.toStringAsFixed(1)} MB") : Text("${img_size_kb.toStringAsFixed(1)} KB"),
              onTap: () {
                setState(() {
                  _image = null;
                });
              },
            ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _selectedImagePreview(){
    if(_image != null){
      return Center(child:Image(image: MemoryImage(_image!)));
    }
    return SizedBox.shrink();
  }

  Uint8List? _video;
  String? _video_extension;

  void selectVideo() async{
    var picked = await pickVideo(ImageSource.gallery);
    Uint8List vid;
    String vid_extension;

    if(picked != null){
      vid = picked[0];
      vid_extension = picked[1];

      setState(() {
      _video = vid;
      _video_extension = vid_extension;
    });
    }
  }

  Widget _selectVideoButton(){
      return ElevatedButton(
        onPressed: () {
          selectVideo();
        }, 
        child: Text("Select video"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),  
            ),
          ),
        ),
      );
  }

  Widget _selectedVideo(){
    if(_video != null){
      var vid_size_kb = _video!.lengthInBytes/(1024);
      var vid_size_mb = _video!.lengthInBytes/(1024*1024);

      return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.video_file, color: AppColors.primaryColor, size: 30,),
                ],
              ),
              title: Text("Video"),
              subtitle: vid_size_mb > 0.5 ? Text("${vid_size_mb.toStringAsFixed(1)} MB") : Text("${vid_size_kb.toStringAsFixed(1)} KB"),
              onTap: () {
                setState(() {
                  _video = null;
                });
              },
            ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _submitButton(){
      return ElevatedButton(
        onPressed: () {
          if(_curr_user != null && _image != null && _video != null){
            _submitForm();
          }
        },
        child: Padding(
          padding: EdgeInsets.all(15), 
          child: Wrap(
            spacing: 7,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                )
              ),
              Icon(
                Icons.check,
                size: 15,
                color: Colors.white,
              ),
            ],
          )
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.orange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),  
            ),
          ),

        ),
        
      );
  }

  final _fbStorage = FBStorage();
  var _firebaseRTDB = FirebaseDB().firebaseRTDB;

  void _submitForm() async{
    SmartDialog.showLoading();

    _firebaseRTDB.ref('content').once().then((value) async {
      var curr_count = value.snapshot.children.length;

      String imageUrl = await _fbStorage.uploadFileToStorage('users/ar/image/${curr_count}', _image!, _image_extension!);
      String videoUrl = await _fbStorage.uploadFileToStorage('users/ar/video/${curr_count}', _video!, _video_extension!);

      DatabaseReference ref = _firebaseRTDB.ref("content/${user?.uid}/");
      await ref.push().set({
        "uid": user?.uid,
        "type": "video",
        "img_url": imageUrl,
        "vid_url": videoUrl,
      });

    }).then((value){
      Navigator.pop(context);
      SmartDialog.dismiss();
    });
    
  }
}