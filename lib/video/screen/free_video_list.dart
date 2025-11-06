// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/video/viewmodel/video_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FreeVideoList extends StatefulWidget {
  const FreeVideoList({ super.key});

  @override
  State<FreeVideoList> createState() => _FreeVideoListState();
}

class _FreeVideoListState extends State<FreeVideoList> {
  String videoId = "";
  YoutubePlayerController? controller;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    VideoViewModel videoViewModel =
        Provider.of<VideoViewModel>(context, listen: false);
    videoViewModel.clearVideoList();
    videoViewModel.fetchFreeVideoList().then((val) {
      setState(() {
        if (videoViewModel.freeVideoList.isNotEmpty) {
          videoId =
              YoutubePlayer.convertUrlToId(videoViewModel.freeVideoList[0].link)!;

          controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              // forceHD: true,
              // loop: true,
              controlsVisibleAtStart: true,
              hideThumbnail: true,
              enableCaption: false,
            ),
          );
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller?.pause();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 10, right: 10),
                color: const Color(0xFF09636E),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    TextViewBold(
                        textContent: "Video".toUpperCase(), textSizeNumber: 17),
                    const Spacer(),
                  ],
                )),
            Expanded(
                child: controller != null
                    ? YoutubePlayerBuilder(
                        onExitFullScreen: () {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown
                          ]);
                        },
                        onEnterFullScreen: () {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight
                          ]);
                        },
                        player: YoutubePlayer(
                          controller: controller!,
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
                                  playedColor: Colors.red,
                                  handleColor: Colors.white),
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
                        builder: (context, player) => Column(children: [
                              player,
                              Consumer<VideoViewModel>(
                                builder: (context, videoDataProvider, child) {
                                  return Expanded(
                                      child: ListView.builder(
                                    controller: scrollController,
                                    itemCount:
                                        videoDataProvider.freeVideoList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            controller!.pause();
                                            videoId =
                                                YoutubePlayer.convertUrlToId(
                                                    videoDataProvider
                                                        .freeVideoList[index]
                                                        .link)!;
                                            controller!.load(videoId);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: Material(
                                            elevation: 8,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            shadowColor: Colors.white,
                                            color: const Color(0xFF09636E),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                  minHeight: 50),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.lock,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  videoDataProvider
                                                          .freeVideoList[index].link
                                                          .contains(videoId)
                                                      ? const Icon(
                                                          Icons.pause,
                                                          size: 25,
                                                          color: Colors.red,
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8,
                                                                  right: 8),
                                                          child: Image.asset(
                                                            "assets/images/png/youtube.png",
                                                            height: 25,
                                                            width: 25,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                  Expanded(
                                                    child: TextViewBold(
                                                      textContent:
                                                          videoDataProvider
                                                              .freeVideoList[index]
                                                              .title,
                                                      textSizeNumber: 15,
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                      textColor: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ));
                                },
                              ),
                            ]))
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
