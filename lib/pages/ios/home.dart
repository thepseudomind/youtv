import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/main.dart';

import './movies.dart';
import './channels.dart';
import './favorite.dart';
import '../settings.dart';
import '../../pages/live.dart';

class IosHomePage extends StatefulWidget {
  final MainModel _model;
  IosHomePage(this._model);

  @override
  _IosHomePageState createState() => _IosHomePageState();
}

class _IosHomePageState extends State<IosHomePage> {
  String name;
  @override
  void initState() {
    name = widget._model.signedInUser.displayName;
    print(name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          body: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              backgroundColor: widget._model.tabBarColor,
              activeColor: (widget._model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor,
              inactiveColor: (widget._model.darkMode) ? Color(0xFF4F5A6C) : Color(0xFF4F5A6C),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_movies),
                  title: Text('Movies')
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv),
                  title: Text('Live')
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tv),
                  title: Text('Channels')
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.favorite),
                  icon: Icon(Icons.favorite_border),
                  title: Text('Favorites')
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings_solid),
                  title: Text('Settings')
                )
              ]
            ),
            tabBuilder: (BuildContext context, int index){
              if(index == 0){
                return MoviesPage(widget._model);
              }else if(index == 1){
                return LiveStreamPage();
              }else if(index == 2){
                return ChannelsPage();
              }else if(index == 3){
                return IosFavoritePage(model);
              }else{
                return SettingsPage(widget._model);
              }
            },
          )
        );
      }
    );
  }
}