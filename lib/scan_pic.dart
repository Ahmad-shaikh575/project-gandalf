import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'code_editor.dart';

class ScanPic extends StatefulWidget {
  @override
  _ScanPicState createState() => _ScanPicState();
}

class _ScanPicState extends State<ScanPic> {
  File pickedImage;
  final picker = ImagePicker();
  List lines = [];
  String text = '';
  Image image = Image.asset('assets/images/code_image.png');
  Future pickImage() async {
    File temp = (await ImagePicker.pickImage(source: ImageSource.gallery));
    setState(() {
      pickedImage = temp;
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future readText() async {
    File f = await getImageFileFromAssets('code_image.png');
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    lines = [];
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        lines.add(line.text.toString());
      }
    }
    setState(() {
      text = lines.join('\n');
    });
  }

  void openCodeEditor() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Picture'),
      ),
      body: Column(
        children: [
          Center(
            child: pickedImage != null
                ? Container(
                    height: 300,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.fill)),
                  )
                : Container(),
          ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RaisedButton(child: Text('Pick an Image'), onPressed: pickImage),
            SizedBox(
              width: 10,
            ),
            RaisedButton(child: Text('Read Text'), onPressed: readText),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RaisedButton(
                child: Text('Open in Code Editor'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Editor(code: lines),
                      ));
                })
          ]),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, //.horizontal
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
