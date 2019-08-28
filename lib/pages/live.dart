import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LiveStreamPage extends StatefulWidget {
  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  File image;

  Future<void> startCamera() async{
    image = await ImagePicker.pickVideo(source: ImageSource.camera);
  }

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.camera_alt),
      //   onPressed: ()=> startCamera(),
      // ),
    );
  }
}