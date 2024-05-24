import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

pickImage(ImageSource source) async{
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source); 


  if(_file != null){
    var extension = path.extension(_file!.name).replaceAll('.', '');

    return [await _file.readAsBytes(), extension];
  }
}

pickVideo(ImageSource source) async{
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickVideo(source: source); 
  

  if(_file != null){
    var extension = path.extension(_file!.name).replaceAll('.', '');

    return [await _file.readAsBytes(), extension];
  }
}

pickFile() async{

  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File _file = File(result.files.single.path!);
    String basename = path.basename(_file.path);

    var extension = path.extension(basename).replaceAll('.', '');

    return [await _file.readAsBytes(), extension];
  }

  // final ImagePicker _imagePicker = ImagePicker();

  // XFile? _file = await _imagePicker.pickMedia(); 

  // if(_file != null){
  //   var extension = path.extension(_file!.name).replaceAll('.', '');

  //   return [await _file.readAsBytes(), extension];
  // }
}