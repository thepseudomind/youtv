import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../models/channel.dart';

class ShowChannel extends StatefulWidget {
  final Channel _channel;
  final int _index;

  ShowChannel(this._channel, this._index);
  @override
  _ShowChannelState createState() => _ShowChannelState();
}

class _ShowChannelState extends State<ShowChannel> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  Chewie player;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    _videoPlayerController = VideoPlayerController.network(widget._channel.link);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 2.0,
      autoInitialize: true,
      showControlsOnInitialize: false,
      allowFullScreen: true,
      fullScreenByDefault: true,
      isLive: true,
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