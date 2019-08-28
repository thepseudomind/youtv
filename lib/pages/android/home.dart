import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';

import './channels.dart';
import '../../pages/live.dart';
import './movies.dart';
import '../auth.dart';

class HomePage extends StatefulWidget {
  final MainModel model;
  HomePage(this.model);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  String displayName;

  void getCurrentUser() async{
    currentUser = await widget.model.getCurrentUser();
    currentUser.reload();
    displayName = currentUser.displayName;
  }

  @override
  void initState(){
    getCurrentUser();
    widget.model.fetchOtherDetails();
    super.initState();
  }

  void signOut(){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (BuildContext context) => AuthPage()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: (model.darkMode) ? Color(0xFF20242F) : Theme.of(context).primaryColor,
                    automaticallyImplyLeading: false,
                    leading: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: (model.displayPicture == null) ? CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: Icon(Icons.person_outline, size: 35.0) 
                      ) : Container(
                        width: 20.0,
                        height: 16.0,
                        margin: EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(model.displayPicture),
                            fit: BoxFit.cover
                          )
                        )
                      )
                    ),
                    title: (displayName == null) ? Text('Menu') : Text(displayName)
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/favorites');
                    },
                    trailing: Icon(Icons.favorite, color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor),
                    title: Text('Favorites'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      // Navigator.pushNamed(context, '/settings');
                    },
                    trailing: Icon(Icons.file_download, color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor),
                    title: Text('Downloads'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/profile');
                    },
                    trailing: Icon(Icons.person_outline, color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor),
                    title: Text('Profile'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/settings');
                    },
                    trailing: Icon(Icons.settings, color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor),
                    title: Text('Settings'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/subscribe');
                    },
                    trailing: Icon(Icons.credit_card, color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor),
                    title: Text('Subscribe'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      model.signOut(signOut);
                    },
                    trailing: Icon(Icons.exit_to_app, color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor),
                    title: Text('Log out'),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: (model.darkMode) ? Color(0xFF20242F) : Theme.of(context).primaryColor,
              title: Text('YOUtv'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.local_movies),
                    text: 'Movies',
                  ),
                  Tab(
                    icon: Icon(Icons.tv),
                    text: 'Channels',
                  ),
                  Tab(
                    icon: Icon(Icons.live_tv),
                    text: 'Live',
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                MoviesPage(model),
                ChannelsPage(),
                LiveStreamPage()
              ],
            ),
          ),
        );
      }
    );
  }
}