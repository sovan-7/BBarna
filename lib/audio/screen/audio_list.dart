// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:b_barna_app/audio/viewModel/audio_viewmodel.dart';
import 'package:b_barna_app/audio/widgets/audio_widget.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:provider/provider.dart';

class AudioList extends StatefulWidget {
  List<String> audioCodeList = [];
  AudioList({required this.audioCodeList, super.key});

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    AudioViewModel audioViewModel =
        Provider.of<AudioViewModel>(context, listen: false);
    audioViewModel.clearAudioList();
    audioViewModel.fetchAudioList(widget.audioCodeList);
    super.initState();
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
                        textContent: "Audio".toUpperCase(), textSizeNumber: 17),
                    const Spacer(),
                  ],
                )),
            Expanded(child: Consumer<AudioViewModel>(
                builder: (context, audioDataProvider, child) {
              return ListView.builder(
                  controller: scrollController,
                  itemCount: audioDataProvider.audioList.length,
                  itemBuilder: (context, index) {
                    return AudioWidget(
                        audioTitle: audioDataProvider.audioList[index].title,
                        audioUrl: audioDataProvider.audioList[index].link);
                  });
            })),
          ],
        ),
      ),
    );
  }
}
