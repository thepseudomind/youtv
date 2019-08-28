import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';

class ProfilePage extends StatefulWidget {
  final MainModel model;
  ProfilePage(this.model);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   Widget gradientFloatingButton(BuildContext context){
    return GestureDetector(
      child: Container(
        width: 55.0,
        height: 55.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   stops: [0.1, 0.3, 0.5, 0.7, 0.9],
          //   colors: [
          //     Colors.yellow[700],
          //     Colors.orange[300],
          //     Colors.orange[500],
          //     Colors.orange[700],
          //     Colors.orange[900]
          //   ]
          // ),
        ),
        child: Icon(Icons.camera_alt, color: Colors.white, size: 30.0),
      )
    );
  }

  Widget profileHero(BuildContext context){
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Card(
          child: Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.teal,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                colors: [
                  Colors.yellow[700],
                  Colors.orange[300],
                  Colors.orange[500],
                  Colors.orange[700],
                  Colors.orange[900]
                ]
              ),
              borderRadius: BorderRadius.circular(2.5)
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (model.displayPicture != null) ? CircleAvatar(
                      radius: 60.0,
                      backgroundImage: FileImage(model.displayPicture),
                    ) : CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.black45,
                      child: Icon(Icons.person_outline, size: 75.0)
                    ),
                    Text(model.signedInUser.displayName, style: TextStyle(color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.w700)),
                    Text(model.signedInUser.email, style: TextStyle(color: Colors.white, fontSize: 16.0))
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget profileDetails(BuildContext context){
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Card(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1.5),
              borderRadius: BorderRadius.circular(2.5)
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Text('Personal Details', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.person_outline),
                          onPressed: (){},
                        ),
                      )
                    ]
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Text('Name', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  trailing: Text(model.signedInUser.displayName, style: TextStyle(fontSize: 16.0))
                  // _user.firstName + ' ' +_user.lastName
                ),
                Divider(),
                ListTile(
                  leading: Text('Email address', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  trailing: Text(model.signedInUser.email, style: TextStyle(fontSize: 16.0))
                ),
                Divider(),
                ListTile(
                  leading: Text('Phone number', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  trailing: (model.userPhoneNumber == null) ? Text('NONE') : Text(model.userPhoneNumber, style: TextStyle(fontSize: 16.0))
                ),
                // Divider(),
                // ListTile(
                //   leading: Text('Another info', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                //   trailing: Text('Details', style: TextStyle(fontSize: 16.0))
                // )
              ]
            )
          )
        );
      }
    );
  }

  Card subscriptionCard(){
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(2.5)
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text('Subscription Status', style: TextStyle(color : Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.credit_card, color : Colors.white),
                      onPressed: (){},
                    ),
                  )
                ]
              ),
            ),
            Divider(color: Colors.white),
            ListTile(
              leading: Text('Subcription plan', style: TextStyle(color : Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
              trailing: Text('YOUBasic', style: TextStyle(color : Colors.white, fontSize: 16.0))
            ),
            Divider(color: Colors.white),
            ListTile(
              leading: Text('Days left', style: TextStyle(color : Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
              trailing: Text('27 days', style: TextStyle(color : Colors.white, fontSize: 16.0))
            ),
            // Divider(color: Colors.white),
            // ListTile(
            //   leading: Text('Another info', style: TextStyle(color : Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
            //   trailing: Text('Details', style: TextStyle(color : Colors.white, fontSize: 16.0))
            // )
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    widget.model.fetchOtherDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: gradientFloatingButton(context),
      appBar: AppBar(
        leading: IconButton(
          icon: (Platform.isIOS) ? Icon(CupertinoIcons.back): Icon(Icons.arrow_back),
          onPressed: ()=> Navigator.pop(context)
        ),
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.create),
            onPressed: (){
              Navigator.pushNamed(context, '/edit-profile');
            }
          )
        ]
      ),
      body: CupertinoPageScaffold(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  profileHero(context),
                  profileDetails(context),
                  subscriptionCard()
                ],
              ),
            )
          ]
        )
      )
    );
  }
}