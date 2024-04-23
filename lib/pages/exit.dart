import 'package:flutter/material.dart';
import 'package:flutter_ar_app/pages/ar_info.dart';
import 'package:flutter_ar_app/widget_tree.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ExitPage extends StatefulWidget {
  const ExitPage({Key? key}) : super(key: key);

  @override
  State<ExitPage> createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  @override
  Widget build(BuildContext context) {
    
    Navigator.pop(context);
    return Scaffold(
    );
  }


}