import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtv/scoped_models/main.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads')
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, model){
          return ListView.builder(
            itemCount: model.downloadMovies.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(model.downloadMovies[index].name)
              );
            }
          );
        },
      )
    );
  }
}