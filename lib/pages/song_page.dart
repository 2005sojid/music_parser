import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SongPage extends StatefulWidget {
  String title;
  String singer;
  String url;
  bool isLooping = false;
  bool isPlaying;
  Duration? currentDuration = Duration.zero;
  Duration? totalDuration = Duration.zero;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  String get _durationText => totalDuration.toString().split('.').first;

  String get _positionText => currentDuration.toString().split('.').first;

  final player;
  SongPage({
    super.key,
    required this.title,
    required this.singer,
    required this.url,
    required this.isPlaying,
    required this.player,
  });

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  Color color = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.player.getDuration().then(
          (Duration? value) => setState(() {
            widget.totalDuration = value;
          }),
        );
    widget.player.getCurrentPosition().then(
          (Duration? value) => setState(() {
            widget.currentDuration = value;
          }),
        );
      
    _initStreams();
  }

  @override
  void dispose() {
    widget._durationSubscription?.cancel();
    widget._positionSubscription?.cancel();
    widget._playerCompleteSubscription?.cancel();
    widget._playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "S O N G",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 250,
            child: Icon(
              Icons.music_note_sharp,
              size: 150,
            ),
          ),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            widget.singer,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 25,
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.currentDuration != null
                    ? '${widget._positionText} / ${widget._durationText}'
                    : widget.totalDuration != null
                        ? widget._durationText
                        : '',
              ),
              Slider(
                onChanged: (value) {
                  final duration = widget.totalDuration;
                  if (duration == null) {
                    return;
                  }
                  final position = value * duration.inMilliseconds;
                  widget.player.seek(Duration(milliseconds: position.round()));
                },
                value: (widget.currentDuration != null &&
                        widget.totalDuration != null &&
                        widget.currentDuration!.inMilliseconds > 0 &&
                        widget.currentDuration!.inMilliseconds <
                            widget.totalDuration!.inMilliseconds)
                    ? widget.currentDuration!.inMilliseconds /
                        widget.totalDuration!.inMilliseconds
                    : 0.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (color == Colors.black) {
                        color = Colors.blue;
                      } else {
                        color = Colors.black;
                      }
                      widget.isLooping = !widget.isLooping;
                    });
                  },
                  icon: Icon(
                    Icons.repeat_sharp,
                    color: color,
                    size: 35,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      pauseOrResume();
                    });
                  },
                  icon: Icon(
                    widget.isPlaying
                        ? Icons.pause_sharp
                        : Icons.play_arrow_sharp,
                    size: 35,
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void pause() async {
    widget.isPlaying = false;
    await widget.player.pause();
  }

  void resume() async {
    widget.isPlaying = true;
    await widget.player.resume();
  }

  void pauseOrResume() {
    if (widget.isPlaying) {
      pause();
    } else {
      resume();
    }
  }



  void _initStreams() {
    widget._durationSubscription =
        widget.player.onDurationChanged.listen((duration) {
      setState(() => widget.totalDuration = duration);
    });

    widget._positionSubscription = widget.player.onPositionChanged.listen(
      (p) => setState(() => widget.currentDuration = p),
    );

    widget._playerCompleteSubscription =
        widget.player.onPlayerComplete.listen((event) {
      setState(() {
        if (widget.isLooping){
           widget.isPlaying = true;
          widget.player.seek(const Duration(seconds: 0));
          widget.player.resume();
        }
        else {
           widget.isPlaying = false;
        }
        widget.currentDuration = Duration.zero;
       
      });
    });

    widget._playerStateChangeSubscription =
        widget.player.onPlayerStateChanged.listen((state) {
      setState(() {
        widget.isPlaying = state == PlayerState.playing ? true : false;
      });
    });
  }
}
