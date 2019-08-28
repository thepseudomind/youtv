import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget appLogo(){
    return Container(
      width: 85.0,
      height: 85.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/sample-logo.png')
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          appLogo(),
          SizedBox(height: 50.0),
          Center(
            child: CircularProgressIndicator()
          )
        ]
      )
    );
  }
}