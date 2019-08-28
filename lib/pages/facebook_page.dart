import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YOUtvFacebook extends StatefulWidget {
  @override
  _YOUtvFacebookState createState() => _YOUtvFacebookState();
}

class _YOUtvFacebookState extends State<YOUtvFacebook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/about'),
          icon: (Platform.isAndroid) ? Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
        ),
        title: Text('YOUtv on Facebook'),
      ),
      body: WebView(
        initialUrl: 'https://web.facebook.com/YoutvAfrica/',
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (finish){
          print('Page fully loaded');
        },
      ),
    );
  }
}