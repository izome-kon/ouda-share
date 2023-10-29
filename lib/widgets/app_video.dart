import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideo extends StatefulWidget {
  final String url;
  const AppVideo({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _AppVideoState createState() => _AppVideoState();
}

class _AppVideoState extends State<AppVideo> {
  late VideoPlayerController _controller;
  bool _mute = false;
  bool _playing = true;
  bool _showAction = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _controller.setLooping(true);
    _controller.initialize();
    _controller.play();
    _showAction = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPlay() {
    setState(() {
      _playing = !_playing;
      _showAction = true;
    });
    if (_playing) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  void _onMute() {
    setState(() {
      _mute = !_mute;
    });
    _controller.setVolume(_mute ? 0.0 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: _onPlay,
            child: VideoPlayer(_controller),
          ),
          AnimatedOpacity(
            opacity: _showAction ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            onEnd: () {
              setState(() {
                _showAction = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Icon(
                _playing ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: InkWell(
              onTap: _onMute,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: Icon(
                  _mute ? Icons.volume_mute_outlined : Icons.volume_up_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
