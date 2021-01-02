import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'code_editor.dart';
import 'scan_pic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      title: 'Project Gandalf',
      home: ScanPic(),
    );
  }
}
