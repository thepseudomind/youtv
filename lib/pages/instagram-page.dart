import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YOUtvInstagram extends StatefulWidget {
  @override
  _YOUtvInstagramState createState() => _YOUtvInstagramState();
}

class _YOUtvInstagramState extends State<YOUtvInstagram> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/about'),
          icon: (Platform.isAndroid) ? Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
        ),
        title: Text('YOUtv on Instagram'),
      ),
      body: WebView(
        initialUrl: 'https://www.instagram.com/youtvafrica/',
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (finish){
          print('Page fully loaded');
        }
      ),
    );
  }
}