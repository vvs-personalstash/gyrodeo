import 'dart:async';
import 'dart:io' as i;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import './VideoPick.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PickFile(),
    );
  }
}

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({Key? key, required this.VideoPath}) : super(key: key);
  final String VideoPath;
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  double x = 0, y = 0, z = 0;
  late VideoPlayerController _controller;
  late Future<void> _video;
  List<double>? _gyroscopeValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(i.File(widget.VideoPath));
    _video = _controller.initialize();
    setState(() {
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          x = event.x;
          y = event.y;
          z = event.z;
          print(event);
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
            _controller.setVolume(y * 150.abs());
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChoosenVideo',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _video,
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
            ),
            SizedBox(
              height: 40,
            ),
            IconButton(
              onPressed: () {
                if (_controller.value.isPlaying) {
                  setState(() {
                    _controller.pause();
                  });
                } else {
                  setState(() {
                    _controller.play();
                  });
                }
              },
              icon: _controller.value.isPlaying
                  ? Icon(IconData(0xe47c, fontFamily: 'MaterialIcons'))
                  : Icon(IconData(0xf00a0, fontFamily: 'MaterialIcons')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
