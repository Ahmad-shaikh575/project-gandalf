import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:code_editor/code_editor.dart';
import 'dart:io';
import 'scan_pic.dart';

class Editor extends StatefulWidget {
  final List code;
  Editor({Key key, @required this.code}) : super(key: key);

  @override
  _EditorState createState() => _EditorState(code);
}

class _EditorState extends State<Editor> {
  final List code_from_pic;
  String _code;

  _EditorState(this.code_from_pic);

  Future<List<String>> _loadQuestions() async {
    List<String> questions = [];
    await rootBundle.loadString('assets/sample.c').then((q) {
      for (String i in LineSplitter().convert(q)) {
        questions.add(i);
      }
    });
    return questions;
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

  _setup() async {
    // Retrieve the questions (Processed in the background)
    List<String> questions = await _loadQuestions();

    // Notify the UI and display the questions
    setState(() {
      List code_from_pi = ["print('hello world')", "print()"];
      _code = code_from_pic.join("\n");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> contentOfPage1 = [
      "<!DOCTYPE html>",
      "<html lang='fr'>",
      "\t<body>",
      "\t\t<a href='page2.html'>go to page 2</a>",
      "\t</body>",
      "</html>",
    ];

    List<FileEditor> files = [
      FileEditor(
        name: "program.py",
        language: "python",
        code: _code, // [code] needs a string
      )
    ];

    EditorModel model = new EditorModel(
      files: files, // the files created above
      // you can customize the editor as you want
      styleOptions: new EditorModelStyleOptions(
        fontSize: 16,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Code Editor'),
          backgroundColor: Colors.deepPurpleAccent.shade700,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CodeEditor(
                model: model,
                disableNavigationbar: false,
                onSubmit: (String language, String value) {
                  print("language = $language");
                  print("value = '$value'");
                },
              ),
              SizedBox(
                height: 100,
              ),
              FlatButton(
                  height: 100,
                  minWidth: 200,
                  onPressed: () {},
                  child: Text(
                    "Compile",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueGrey.shade700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
            ],
          ),
        ));
  }
}
