import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YOUtvYouTube extends StatefulWidget {
  @override
  _YOUtvYouTubeState createState() => _YOUtvYouTubeState();
}

class _YOUtvYouTubeState extends State<YOUtvYouTube> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/about'),
          icon: (Platform.isAndroid) ? Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
        ),
        title: Text('YOUtv on YouTube'),
      ),
      body: WebView(
        initialUrl: 'https://www.youtube.com/channel/UCwhVoe36eddwQGMs2pjBoqA',
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (finish){
          print('Page fully loaded');
        },
      ),
    );
  }
}