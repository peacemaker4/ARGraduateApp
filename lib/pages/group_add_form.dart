import 'dart:convert';
import 'dart:typed_data';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
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

class GroupAddFormPage extends StatefulWidget {
  const GroupAddFormPage({Key? key}) : super(key: key);

  @override
  State<GroupAddFormPage> createState() => _GroupAddFormPageState();
}

class _GroupAddFormPageState extends State<GroupAddFormPage> with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  var switchValue = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: 
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Color.fromARGB(255, 57, 123, 255),
          shadowColor: Color.fromARGB(84, 0, 0, 0),
          leading: SizedBox.shrink(),
          leadingWidth: 0,
          title: Text("Add group"),
          actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () {
              // handle the press
              Navigator.pop(context);

            },
          ),
        ],
          // title: const Text('Admin', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500)), 
        ),
        backgroundColor: Color.fromARGB(255, 244, 242, 244),
        body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: [
            SizedBox(height: 24,),
            _groupnameInput(),
            _institutionNameInput(),
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
      child: Text("Add Group", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Montserrat",),),
    );
  }

  late final TextEditingController _controllerGroupName = TextEditingController();

  Widget _groupnameInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _controllerGroupName,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: (value) {
                      if(!value!.isEmpty){
                        if(value.length < 3){
                          return "Group name should be longer";
                        }
                        else{
                          return null;
                        }
                      }
                    },
        obscuringCharacter: '*',
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(18, 24, 12, 16),
          labelText: "Group name",
          labelStyle: TextStyle(fontFamily: "Montserrat",),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Enter group name",
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

  late final TextEditingController _controllerInstitutionName = TextEditingController();

  Widget _institutionNameInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _controllerInstitutionName,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: (value) {
                      if(!value!.isEmpty){
                        if(value.length < 2){
                          return "Institution name should be longer";
                        }
                        else{
                          return null;
                        }
                      }
                    },
        obscuringCharacter: '*',
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(18, 24, 12, 16),
          labelText: "Institution name",
          labelStyle: TextStyle(fontFamily: "Montserrat",),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Enter institution name",
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

  Widget _submitButton(){
      return ElevatedButton(
        onPressed: () {
          if(_controllerGroupName.text.isNotEmpty && _controllerInstitutionName.text.isNotEmpty){
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
                "Create",
                style: TextStyle(
                  color: Colors.white,
                )
              ),
              Icon(
                Icons.add,
                size: 15,
                color: Colors.white,
              ),
            ],
          )
        ),
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

  final _fbStorage = FBStorage();
  var _firebaseRTDB = FirebaseDB().firebaseRTDB;

  void _submitForm() async{
    SmartDialog.showLoading();

    DatabaseReference ref = _firebaseRTDB.ref("groups/");
      await ref.push().set({
        "group_name": _controllerGroupName.text,
        "institution": _controllerInstitutionName.text,
    }).then((value) {
      Navigator.pop(context);
      SmartDialog.dismiss();
    } 
    );
    
  }
}