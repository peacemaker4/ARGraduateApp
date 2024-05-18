import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

pickImage(ImageSource source) async{
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source); 

  var extension = path.extension(_file!.name).replaceAll('.', '');

  if(_file != null){
    return [await _file.readAsBytes(), extension];
  }
}

pickVideo(ImageSource source) async{
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickVideo(source: source); 
  
  var extension = path.extension(_file!.name).replaceAll('.', '');

  if(_file != null){
    return [await _file.readAsBytes(), extension];
  }
}