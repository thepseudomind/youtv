import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:video_player/video_player.dart';
import 'package:youtv/models/download.dart';
import 'package:youtv/pages/local_movie.dart';
import 'package:youtv/pages/movie.dart';
import 'package:youtv/utilities/utils.dart';
import '../scoped_models/main.dart';
import '../models/movie.dart';

import '../pages/comments.dart';

class MovieDetail extends StatefulWidget {
  final MainModel _model;
  final Movie _movie;
  final int _index;

  MovieDetail(this._model, this._movie, this._index);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  VideoPlayerController controller;
  bool visible;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    visible = true;
    controller = VideoPlayerController.network(widget._movie.trailer)
    ..initialize().then((_){
      setState((){});
    });
    //Check for movie download status
    widget._model.checkForDownload(widget._movie);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showSnackBar(BuildContext context){
    Navigator.pop(context);
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text('Download started. Check your Downloads tab'),
      // action: SnackBarAction(
      //   label: 'VIEW',
      //   textColor: Colors.white,
      //   onPressed: ()=> {}
      //   // Navigator.pushNamed(context, '/download');
      // ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget movieHero(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.black
      ),
      child: AspectRatio(
        aspectRatio: 4/3,
          child: GestureDetector(
            onTap: (){
              setState(() {visible = !visible;});
            },
            child: Stack(
              children: <Widget>[
                VideoPlayer(controller),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: (visible) ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: IconButton(
                          onPressed: (){
                            setState(() {
                              if(controller.value.position >= controller.value.duration){
                                  controller.initialize();
                                  controller.play();
                              }else{
                                (controller.value.isPlaying) ? controller.pause() : controller.play();
                              }
                              visible = !visible;
                            });
                          },
                          icon: Icon((controller.value.isPlaying) ? Icons.pause : Icons.play_circle_outline),
                          color: Colors.white,
                          iconSize: 100.0,
                        ),
                      )
                    )
                  )
                ),
              ],
            )
          )
      )
      // child: Stack(
      //   children: <Widget>[
      //     Positioned(
      //       child: ScopedModelDescendant<MainModel>(
      //         builder: (BuildContext context, Widget child, MainModel model){
      //           return IconButton(
      //             onPressed: (){
      //               model.likeMovie(widget._movie);
      //             },
      //             icon : (widget._movie.isLiked) ? Icon(Icons.favorite, color: Colors. red) : Icon(Icons.favorite_border, color: Colors.white)
      //           );
      //         },
      //       ),
      //       right: 5.0,
      //     ),
      //     Positioned(
      //       child: Icon(Icons.playlist_add, color: Colors.white,),
      //       top: 12.0,
      //       right: 50.0,
      //     ),
      //     playerWidget
      //   ],
      // ),
    );
  }

  Widget movieDescription(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        border: Border(
          bottom : BorderSide(
            color: Colors.grey,
            width: 0.5
          )
        )
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('DESCRIPTION', style: TextStyle(fontSize : 12.0, fontWeight: FontWeight.bold))
                )
              ),
              Expanded(
                flex: 2,
                child: Container(),
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(widget._movie.excerpt, style: TextStyle(fontSize : 14.0))
                )
              )
            ],
          ),
          SizedBox(height: 10.0),
          Divider(color: Colors.grey,),
          //GENRE
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('GENRE', style: TextStyle(fontSize : 12.0, fontWeight: FontWeight.bold))
                )
              ),
              Expanded(
                flex: 2,
                child: Container(),
              )
            ],
          ),
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(widget._movie.categories, style: TextStyle(fontSize : 14.0))
                )
              )
            ],
          )
        ]
      ),
    );
  }

  Widget movieCastTitle(){
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('CASTS', style: TextStyle(fontSize : 12.0, fontWeight: FontWeight.bold))
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Widget movieCharacters(){
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5
            )
          )
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget._movie.cast.map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: <Widget>[
                    // CircleAvatar(
                    //   radius: 30.0,
                    //   backgroundImage: NetworkImage(e.imageUrl)
                    // ),
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(e.imageUrl),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(e.name)
                    )
                  ],
                ),
              )
            ).toList()
          ),
        ),
      )
    );
  }

  Widget galleryTitle(){
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('GALLERY', style: TextStyle(fontSize : 12.0, fontWeight: FontWeight.bold))
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Widget galleryGrid(){
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 0.68
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index){
            return Image.network(widget._movie.galleryImages[index].imageUrl);
          },
          childCount: widget._movie.galleryImages.length
        )
      )
    );
  }

  Widget modalToDisplay(){
    if(widget._model.status == downloadStatus.Downloading){
      return Card(
        child: Container(
          height: 80.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget._movie.title),
              SizedBox(height: 5.0),
              widget._model.downloadProgress == "Completed" ? Text('${widget._model.totalSz}MB') : Text('${widget._model.recSz}MB/${widget._model.totalSz}MB'),
              SizedBox(height: 5.0),
              widget._model.downloadProgress == "Completed" ? Text('Download complete') : LinearProgressIndicator(
                value: double.parse(widget._model.downloadProgress),
              )
            ]
          )
        )
      );
    }else if(widget._model.status == downloadStatus.Downloaded){
      return Container(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return LocalMovie(widget._model, widget._movie);
                  }
                ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 25.0,
                    child: Icon(Icons.play_arrow, color: Colors.white)
                  ),
                  SizedBox(height: 5.0),
                  Text('Play Movie'),
                ]
              ),
            ),
            GestureDetector(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(
              builder: (context)=> StreamPage(index: widget._index)
            )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 25.0,
                    child: Icon(Icons.live_tv, color: Colors.white)
                  ),
                  SizedBox(height: 5.0),
                  Text('Stream movie')
                ]
              )
            )
          ],
        )
      );
    }else{
      return Container(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                widget._model.downloadMovie(Download(name: widget._movie.title, src: widget._movie.trailer));
                //Download(name: widget._movie.title, src: widget._movie.trailer)
                //Navigator.pushNamed(context, '/download/' + widget._index.toString());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 25.0,
                    child: Icon(Icons.file_download, color: Colors.white)
                  ),
                  SizedBox(height: 5.0),
                  Text('Download movie'),
                ]
              ),
            ),
            GestureDetector(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(
              builder: (context)=> StreamPage(index: widget._index)
            )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 25.0,
                    child: Icon(Icons.live_tv, color: Colors.white)
                  ),
                  SizedBox(height: 5.0),
                  Text('Stream movie')
                ]
              )
            )
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget._movie.title),
            actions: <Widget>[
              IconButton(
                onPressed: (){
                  model.likeMovie(widget._movie);
                },
                icon : (widget._movie.isLiked) ? Icon(Icons.favorite, color: Colors.white) : Icon(Icons.favorite_border, color: Colors.white)
              )
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  movieHero(),
                  movieDescription(),
                ]),
              ),
              movieCastTitle(),
              movieCharacters(),
              galleryTitle(),
              galleryGrid()
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: (){

          //   },
          //   child: Icon(Icons.comment),
          //   tooltip: 'Comments',
          // ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1.0
                )
              )
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: IconButton(
                    icon: Icon(Icons.message, color: (model.darkMode) ? Colors.black : Colors.black),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => CommentsPage(widget._movie, model, widget._index)
                      ));
                    },
                  ),
                ),
                SizedBox(width: 5.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: IconButton(
                    icon: Icon(Icons.share, color: (model.darkMode) ? Colors.white : Colors.white),
                    onPressed: (){},
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(platform == TargetPlatform.iOS){
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context){
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: Text('Stream movie'),
                                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=> StreamPage(index: widget._index)
                                  ))
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Download movie'),
                                  onPressed: (){
                                    showSnackBar(context);
                                    // model.downloadMovie();
                                  }
                                )
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: Text('Cancel', style: TextStyle(color: Colors.red)),
                                isDefaultAction: true,
                                onPressed: ()=> Navigator.pop(context)
                              ),
                            );
                          }
                        );
                      }else{
                        showModalBottomSheet(
                          isDismissible: (model.status == downloadStatus.Downloading ? false : true),
                          context: context,
                          builder: (context){
                            return modalToDisplay();
                          }
                        );
                      }
                    },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1.0
                          ),
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Text('WATCH NOW', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                    ),
                  )
                )
              ],
            )
          ),
        );
      }
    );
  }
}