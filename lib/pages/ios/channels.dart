import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../scoped_models/main.dart';

class ChannelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: (model.darkMode) ? Color(0xFF20242F) : Theme.of(context).primaryColor,
            leading: (Platform.isIOS) ? Container() : null,
            title: Text('Channels ', style: TextStyle(color: Colors.white))
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index){
                        return Card(
                          child: Center(
                            child: Image.asset(model.channels[index].logo),
                          ),
                        );
                      },
                      childCount: model.channels.length
                    ),
                  )
                )
              ]
            )
          )
        );
      }
    );
  }
}

