import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';
import '../../models/channel.dart';

class ChannelsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        List<Channel> _channels = model.channels;
        return CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index){
                  return Card(
                    child: Center(
                      child: Image.asset(_channels[index].logo)
                    )
                  );
                },
                childCount: _channels.length
              )
            )
          ],
        );
      },
    );
  }
}