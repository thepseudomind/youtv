import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  Container aboutBanner(){
    return Container(
      color: Colors.grey.shade400,
      height: 300.0,
      child: Center(
        child: Image.asset('assets/youtvlogo.png'),
      )
    );
  }

  Padding aboutText(){
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('YOUtv is an online movie and Television oasis: an application that guarantees its users a relaxing, refreshing and reinvigorating time, local in originality and global in its appeal. It’s the African entertainment experience… Young Original and Urban Television (YOUtv) spotlights Africa’s unique ability to laugh through daunting challenges, we represent colour, culture and class. YOUtv is about you: we celebrate the uniqueness that stands you out from the crowd. The special sound that is your laughter, your love of life and your eager anticipation of a better tomorrow. We are about family: the special bond that we build when we share laughter, the companionship we enjoy in trying times and the desire to bring back the good times. YOUtv is also for the people-friendly brand that seeks a viable medium to reach the largest and most dynamic viewers population on the continent. Developed by BeeTcore and powered by Black Collar 360Media.', style: TextStyle(fontSize: 18.0)),
    );
  }

  Column socialMediaLinks(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Connect with us on'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: ()=> Navigator.pushReplacementNamed(context, '/facebook-page'),
                child: Text('Facebook', style: TextStyle(color: Colors.blueAccent))
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: ()=> Navigator.pushReplacementNamed(context, '/instagram-page'),
                child: Text('Instagram', style: TextStyle(color: Colors.blueAccent))
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: ()=> Navigator.pushReplacementNamed(context, '/youtube-page'),
                child: Text('YouTube', style: TextStyle(color: Colors.blueAccent))
              ),
              SizedBox(width: 10.0),
              Text('Twitter'),
              SizedBox(width: 10.0),
              Text('LinkedIn')
            ],
          ),
      ],
    );
  }

  Row sponsors(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/blackcollar.png', height: 70.0),
        SizedBox(width: 20.0),
        Image.asset('assets/beetcore.png', height: 70.0)
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About YOUtv')
      ),
      body: ListView(
        children: <Widget>[
          aboutBanner(),
          aboutText(),
          SizedBox(
            height: 20.0
          ),
          socialMediaLinks(context),
          SizedBox(
            height: 30.0
          ),
          sponsors()
        ]
      )
    );
  }
}