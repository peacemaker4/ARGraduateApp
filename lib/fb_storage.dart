import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/models/DBUser.dart';

class FBStorage{
  final storage = FirebaseStorage.instance;

  Future<String> uploadFileToStorage(String path, Uint8List file, String file_type) async{
    Reference ref = storage.ref().child(path);
    UploadTask uploadTask = ref.putData(file, SettableMetadata(contentType: file_type));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;

  }
}