import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class StreamPage extends StatefulWidget {
  final int index;
  StreamPage({this.index});

  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
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
    _videoPlayerController = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/youtvapi.appspot.com/o/Concussion.mp4?alt=media&token=9c15437e-5b60-4ecb-93c0-3bdcfd1834a9');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 2.0,
      autoInitialize: true,
      showControlsOnInitialize: false,
      allowFullScreen: true,
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



// return AspectRatio(
//             aspectRatio: (orientation == Orientation.landscape) ? 16/9 : 16/9,
//             child: (orientation == Orientation.landscape) ? Container(color: Colors.yellow): Container(color: Colors.red)
//           );



// import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';

// class ShowMovie extends StatefulWidget {
//   final int index;
//   ShowMovie({this.index});

//   @override
//   _ShowMovieState createState() => _ShowMovieState();
// }

// class _ShowMovieState extends State<ShowMovie> {

//   VideoPlayerController videoPlayerController;
//   ChewieController chewieController;
//   Chewie playerWidget;

//     void initState(){
//     videoPlayerController = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/youtvapi.appspot.com/o/Concussion.mp4?alt=media&token=9c15437e-5b60-4ecb-93c0-3bdcfd1834a9');

//     chewieController = ChewieController(
//       fullScreenByDefault: true,
//       deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//       videoPlayerController: videoPlayerController,
//       aspectRatio: 16 / 9,
//       autoPlay: true
//     );

//     chewieController.enterFullScreen();

//     playerWidget = Chewie(
//       controller: chewieController,
//     );

//     super.initState();
//   }

//   @override
//   void dispose() {
//     videoPlayerController.dispose();
//     chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: <Widget>[
//             Positioned(
//               top: 5.0,
//               right: 5.0,
//               child: IconButton(
//                 onPressed: ()=> Navigator.pushReplacementNamed(context, '/movies/' + widget.index.toString()),
//                 icon: Icon(Icons.cancel, size: 30.0,),
//               )
//             ),
//             playerWidget
//           ]
//         )
//       )
//     );
//   }
// }