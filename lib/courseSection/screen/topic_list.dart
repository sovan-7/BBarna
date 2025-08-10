import 'package:flutter/material.dart';
import 'package:b_barna_app/audio/screen/audio_list.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/courseSection/viewModel/topic_viewmodel.dart';
import 'package:b_barna_app/utils/helper.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:b_barna_app/video/screen/video_list.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TopicsList extends StatefulWidget {
  String? unitCode;
  String? unitName;
  TopicsList({required this.unitCode, required this.unitName, super.key});

  @override
  State<TopicsList> createState() => _TopicsState();
}

class _TopicsState extends State<TopicsList> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    TopicViewModel topicViewModel =
        Provider.of<TopicViewModel>(context, listen: false);
    topicViewModel.getTopicList(widget.unitCode ?? stringDefault);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppHeader(
              shouldLanguageIconVisible: false,
              isBackVisible: true,
            ),
            Consumer<TopicViewModel>(
              builder: (context, topicDataProvider, child) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 95,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      topicDataProvider
                          .getTopicList(widget.unitCode ?? stringDefault);
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: topicDataProvider.topicList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          constraints: const BoxConstraints(
                              minHeight: 100, maxHeight: 100),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400, width: 0.7),
                            borderRadius: BorderRadius.circular(8),
                            color: topicDataProvider.cardColorList[index],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                        child: Icon(
                                      sp!.getBoolFromPref(SPKeys.canTopicAccess)
                                          ? Icons.lock_open
                                          : Icons.lock,
                                      color: topicDataProvider
                                          .textColorList[index],
                                      size: 20,
                                    )),
                                    TextSpan(
                                      text: topicDataProvider
                                          .topicList[index].name,
                                      style: TextStyle(
                                        color: topicDataProvider
                                            .textColorList[index],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Visibility(
                                    visible: topicDataProvider.topicList[index]
                                        .quizCodeList.isNotEmpty,
                                    child: InkWell(
                                      onTap: () {
                                        if (sp!.getBoolFromPref(
                                            SPKeys.canTopicAccess)) {
                                          Navigator.pushNamed(context,
                                              RouteName.quizScreenRoute,
                                              arguments: {
                                                "quizCodeList":
                                                    topicDataProvider
                                                        .topicList[index]
                                                        .quizCodeList
                                              });
                                        } else {
                                          Helper.showSnackBarMessage(
                                              msg:
                                                  "Please subscribe our course",
                                              isSuccess: false);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.laptop_chromebook_outlined,
                                            color: topicDataProvider
                                                .textColorList[index],
                                            size: 18,
                                          ),
                                          Text(
                                            " - ${topicDataProvider.topicList[index].quizCodeList.length}",
                                            style: TextStyle(
                                                color: topicDataProvider
                                                    .textColorList[index],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: topicDataProvider.topicList[index]
                                        .pdfCodeList.isNotEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: InkWell(
                                        onTap: () {
                                          if (sp!.getBoolFromPref(
                                              SPKeys.canTopicAccess)) {
                                            Navigator.pushNamed(
                                                context, RouteName.pdfList,
                                                arguments: {
                                                  "pdfCodeList":
                                                      topicDataProvider
                                                          .topicList[index]
                                                          .pdfCodeList,
                                                });
                                          } else {
                                            Helper.showSnackBarMessage(
                                                msg:
                                                    "Please subscribe our course",
                                                isSuccess: false);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf,
                                              color: topicDataProvider
                                                  .textColorList[index],
                                              size: 18,
                                            ),
                                            Text(
                                              " - ${topicDataProvider.topicList[index].pdfCodeList.length}",
                                              style: TextStyle(
                                                  color: topicDataProvider
                                                      .textColorList[index],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: topicDataProvider.topicList[index]
                                        .videoCodeList.isNotEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: InkWell(
                                        onTap: () {
                                          if (sp!.getBoolFromPref(
                                              SPKeys.canTopicAccess)) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => VideoList(
                                                        videoCodeList:
                                                            topicDataProvider
                                                                .topicList[
                                                                    index]
                                                                .videoCodeList)));
                                          } else {
                                            Helper.showSnackBarMessage(
                                                msg:
                                                    "Please subscribe our course",
                                                isSuccess: false);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.play_circle,
                                              color: topicDataProvider
                                                  .textColorList[index],
                                              size: 18,
                                            ),
                                            Text(
                                              " - ${topicDataProvider.topicList[index].videoCodeList.length}",
                                              style: TextStyle(
                                                  color: topicDataProvider
                                                      .textColorList[index],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: topicDataProvider.topicList[index]
                                        .audioCodeList.isNotEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: InkWell(
                                        onTap: () {
                                          if (sp!.getBoolFromPref(
                                              SPKeys.canTopicAccess)) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AudioList(
                                                        audioCodeList:
                                                            topicDataProvider
                                                                .topicList[
                                                                    index]
                                                                .audioCodeList)));
                                          } else {
                                            Helper.showSnackBarMessage(
                                                msg:
                                                    "Please subscribe our course",
                                                isSuccess: false);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.audiotrack,
                                              color: topicDataProvider
                                                  .textColorList[index],
                                              size: 18,
                                            ),
                                            Text(
                                              " - ${topicDataProvider.topicList[index].audioCodeList.length}",
                                              style: TextStyle(
                                                  color: topicDataProvider
                                                      .textColorList[index],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
