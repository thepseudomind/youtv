import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtv/models/movie.dart';
import 'package:youtv/scoped_models/main.dart';

class LocalMovie extends StatefulWidget {
  final MainModel model;
  final Movie movie;
  LocalMovie(this.model, this.movie);

  @override
  _LocalMovieState createState() => _LocalMovieState();
}

class _LocalMovieState extends State<LocalMovie> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  Chewie player;
  dynamic videoPath;

  Future<void> fetchFile() async{
    try {
      await widget.model.getMovieFromFile(widget.movie);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    fetchFile();
    _videoPlayerController = VideoPlayerController.file(widget.model.movieStream)
    ..initialize().then((_){
      setState((){});
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 2.0,
      autoInitialize: true,
      showControlsOnInitialize: false,
      allowFullScreen: true,
      autoPlay: false,
      fullScreenByDefault: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      systemOverlaysAfterFullScreen: SystemUiOverlay.values,
      showControls: true,
    );
    _chewieController.enterFullScreen();
    player = Chewie(
      controller: _chewieController
    );
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details){
            Navigator.pop(context);
          },
          child: player,
        )
      );
  }
}