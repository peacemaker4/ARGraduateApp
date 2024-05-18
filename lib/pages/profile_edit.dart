import 'dart:convert';
import 'dart:typed_data';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/fb_storage.dart';
import 'package:flutter_ar_app/firebasedb.dart';
import 'package:flutter_ar_app/models/DBUser.dart';
import 'package:flutter_ar_app/pages/role_request_modal.dart';
import 'package:flutter_ar_app/utils/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shimmer/shimmer.dart';

import '../values/app_colors.dart';
import 'login.dart';

final User? user = Auth().currentUser;

final _firebaseRTDB = FirebaseDB().firebaseRTDB;

final _fbStorage = FBStorage();

var _dbuser;

class ProfileEditPage extends StatefulWidget {
  DBUser dbuser;

  ProfileEditPage({Key? key, required this.dbuser}) : super(key: key);

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState(dbuser);
}

class _ProfileEditPageState extends State<ProfileEditPage> with TickerProviderStateMixin {

  late final AnimationController controller;

  late final Animation<Offset> offset;

  DBUser dbuser;

  _ProfileEditPageState(this.dbuser){}

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

  Uint8List? _image;
  String? _extension;

   void selectImage() async{
    var picked = await pickImage(ImageSource.gallery);
    Uint8List img;
    String ext;
    if(picked != null){
      img = picked[0];
      ext = picked[1];

      setState(() {
      _image = img;
      _extension = ext;
    });
    }
  }

  

  void saveProfile() async{
    // var mime = lookupMimeType('', headerBytes: _image);
    // var extension = extensionFromMime(mime!);

    String imageUrl = await _fbStorage.uploadFileToStorage('users/profile/${user?.uid}', _image!, _extension!);
  
    DatabaseReference ref = _firebaseRTDB.ref("users/${user?.uid}");
      await ref.set({
        "uid": user?.uid,
        "email": user?.email,
        "username": dbuser.username,
        "role": dbuser.role,
        "img_url": "${imageUrl}"
      });
  }

  Widget _userInfo(){
    return Column(
            children: [
              SettingsItem(
                onTap: () {},
                icons: Icons.email,
                iconStyle: IconStyle(backgroundColor: AppColors.primaryColor),
                title: 'Email',
                subtitle: '${user?.email}',
                trailing: Text(""),
              ),
              SettingsItem(
                onTap: () {},
                icons: Icons.insert_link_rounded,
                iconStyle: IconStyle(backgroundColor: AppColors.primaryColor),
                title: 'UID',
                subtitle: '${dbuser.uid}',
                trailing: Text(""),
              ),
              SettingsItem(
                onTap: () {},
                icons: Icons.person,
                iconStyle: IconStyle(backgroundColor: AppColors.primaryColor),
                title: 'Username',
                subtitle: '${dbuser.username}',
                trailing: Text(""),
              ),
              SettingsItem(
                onTap: () {
                  _roleModalScreen(dbuser.role);
                },
                icons: Icons.co_present_rounded,
                iconStyle: IconStyle(backgroundColor: AppColors.primaryColor),
                title: 'Role',
                subtitle: '${dbuser.role}',
              ),
              SettingsItem(
                onTap: () {
                  _roleModalScreen(dbuser.role);
                },
                icons: Icons.co_present_rounded,
                iconStyle: IconStyle(backgroundColor: AppColors.primaryColor),
                title: 'img_url',
                subtitle: '${dbuser.img_url}',
              ),
            ],
          );
  }

  void _roleModalScreen(role){
    

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      context: context, 
      builder: (context) => RoleRequestModal(role: role,),
    );
  }

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
                    'Upload image',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
                onPressed: (){
                  selectImage();
                }
            );
  }

  Widget _saveButton(){
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
                    'Save profile',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
                onPressed: (){
                  saveProfile();
                }
            );
  }

  Widget _header(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
      child: Text("Profile EDIT", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),),
    );
  }

  late final TextEditingController _controllerUsername = TextEditingController();

  Widget _usernameInput() {
    _controllerUsername.text = dbuser.username.toString();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _controllerUsername,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: (value) {
                      if(!value!.isEmpty){
                        if(value.length < 4){
                          return "Username should be longer";
                        }
                        else{
                          return null;
                        }
                      }
                    },
        obscuringCharacter: '*',
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 12, 16),
          labelText: "Username",
          labelStyle: TextStyle(fontFamily: "Montserrat",),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Enter username",
          hintStyle: TextStyle(color: Color.fromARGB(255, 200, 200, 200),fontFamily: "Montserrat", fontSize: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _emailInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        initialValue: dbuser.email,
        readOnly: true,
        decoration: InputDecoration(
          icon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 12, 16),
          labelText: "Email",
          labelStyle: TextStyle(fontFamily: "Montserrat",),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: TextStyle(color: Color.fromARGB(255, 200, 200, 200),fontFamily: "Montserrat", fontSize: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
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
        title: Text("Profile Edit"),
        // title: const Text('ARGraduateApp', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500)), //, style: TextStyle(fontFamily: "Poppins", weight: 100)
        // centerTitle: true,
        ),
        body: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
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
                      _image != null ?
                                CircleAvatar(
                        radius: 48, 
                        backgroundImage: MemoryImage(_image!),
                      )
                      :
                      (dbuser.img_url != ""
                      ?
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                            NetworkImage(dbuser.img_url!),
                        )
                      :
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey.shade300,
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
                  // Text(
                  //     '${dbuser.email}',
                  //     style: TextStyle(
                  //       letterSpacing: 0.4,
                  //     ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  _emailInput(),
                  SizedBox(
                    height: 4,
                  ),
                  _usernameInput(),
                  // _userInfo(),
                  _bouncingButton(),
                  _saveButton()
                      ],
                    ),
            ),
          ),
      )), 
      onRefresh:() async {
        setState(() {
          
        });
      },
    );
  }

}