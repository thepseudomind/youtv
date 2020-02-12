import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DownloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            title: Text('Downloads'),
          ),
          body: Center(
            child: Text('No downloads yet')
          ),
        );
      }
    );
  }
}
