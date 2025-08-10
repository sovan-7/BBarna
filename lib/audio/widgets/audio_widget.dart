// ignore_for_file: must_be_immutable

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:rxdart/rxdart.dart';

class AudioWidget extends StatefulWidget {
  String audioTitle = stringDefault;
  String audioUrl = stringDefault;
  AudioWidget({required this.audioTitle, required this.audioUrl, super.key});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  AudioPlayer player = AudioPlayer();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferPosition, duration) => PositionData(
              position, bufferPosition, duration ?? Duration.zero));
  @override
  void initState() {
    player.setUrl(widget.audioUrl);
    player.setLoopMode(LoopMode.off);
    super.initState();
  }

  @override
  void dispose() {
    player.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF09636E),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextViewBold(
              textContent: "Title: ${widget.audioTitle}",
              textColor: Colors.white,
              textSizeNumber: 15,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, AsyncSnapshot<PlayerState> snapshot) {
                    final playerState = snapshot.data;
                    var processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (snapshot.hasData) {
                      if (!playing!) {
                        return InkWell(
                            onTap: player.play,
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 25,
                              color: Colors.white,
                            ));
                      } else if (processingState != ProcessingState.completed) {
                        return InkWell(
                            onTap: player.pause,
                            child: const Icon(
                              Icons.pause_rounded,
                              size: 30,
                              color: Colors.white,
                            ));
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                    return InkWell(
                        onTap: () {
                          player.setUrl(widget.audioUrl);
                          player.play();
                        },
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 30,
                          color: Colors.white,
                        ));
                  },
                ),
                const SizedBox(
                  width: 25,
                ),
                SizedBox(
                  width: 150,
                  child: StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, AsyncSnapshot<PositionData> snapshot) {
                        var positionData = snapshot.data;
                        positionData =
                            positionData?.position == positionData?.duration
                                ? null
                                : snapshot.data;
                        return snapshot.hasData
                            ? ProgressBar(
                                barHeight: 3,
                                thumbGlowRadius: 5,
                                thumbRadius: 8,
                                baseBarColor: Colors.white,
                                bufferedBarColor: Colors.white,
                                progressBarColor: Colors.white,
                                thumbColor: Colors.white,
                                progress:
                                    positionData?.position ?? Duration.zero,
                                buffered: positionData?.bufferPosition ??
                                    Duration.zero,
                                total: positionData?.duration ?? Duration.zero,
                                onSeek: player.seek,
                                timeLabelPadding: 5,
                                timeLabelTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              )
                            : const SizedBox();
                      }),
                )
              ],
            )
          ],
        ));
  }
}

class PositionData {
  PositionData(this.position, this.bufferPosition, this.duration);
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;
}
