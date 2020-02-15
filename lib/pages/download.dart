import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtv/models/movie.dart';
import 'package:youtv/pages/local_movie.dart';
import 'package:youtv/scoped_models/main.dart';

class DownloadPage extends StatefulWidget {
  final MainModel model;
  DownloadPage(this.model);
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    widget.model.getListOfDownloads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return WillPopScope(
          onWillPop: (){
            model.clearDownloadsList();
            Navigator.pop(context);
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Downloads'),
            ),
            body: (model.downloadedMovies.length == 0) ? Center(
              child: Text('No downloads yet')
            ) : ListView.builder(
              itemCount: model.downloadedMovies.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    title: Text(model.downloadedMovies[index]),
                    trailing: IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.play_arrow),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            Movie movieToSend;
                            for (var i = 0; i < model.movies.length; i++) {
                              if(model.movies[i].title == model.downloadedMovies[index]){
                                movieToSend = model.movies[i];
                              }
                            }
                            return LocalMovie(model, movieToSend);
                          }
                        ));
                      },
                    )
                  )
                );
              }
            ),
          )
        );
      }
    );
  }
}
