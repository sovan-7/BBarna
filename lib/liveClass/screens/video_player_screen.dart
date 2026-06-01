import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  final YoutubePlayerController controller;
  final VoidCallback onPlayPause;
  Widget childData;

  VideoPlayerScreen({
    super.key,
    required this.controller,
    required this.onPlayPause,
    required this.childData,
  });

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      },
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      },
      player: YoutubePlayer(
        controller: controller,
        liveUIColor: Colors.red,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        aspectRatio: 16 / 9,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.white,
        ),
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
                playedColor: Colors.red, handleColor: Colors.white),
          ),
          const PlaybackSpeedButton(
            icon: Icon(
              Icons.speed,
              color: Colors.white,
            ),
          ),
          FullScreenButton(),
        ],
      ),
      builder: (BuildContext p1, Widget p2) {
        return Column(
          children: [
            p2,
            Expanded(
              child: childData,
            ),
          ],
        );
      },
    );
  }
}
