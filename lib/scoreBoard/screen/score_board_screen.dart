// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:b_barna_app/scoreBoard/viewmodel/score_viewmodel.dart';
import 'package:b_barna_app/scoreBoard/widgets/score_board_app_header.dart';
import 'package:b_barna_app/scoreBoard/widgets/topper_list.dart';
import 'package:b_barna_app/scoreBoard/widgets/user_own_result.dart';
import 'package:provider/provider.dart';

class ScoreBoardScreen extends StatefulWidget {
  String quizCode;
  ScoreBoardScreen({required this.quizCode, super.key});

  @override
  State<ScoreBoardScreen> createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {
  @override
  void initState() {
    ScoreViewModel scoreViewModel =
        Provider.of<ScoreViewModel>(context, listen: false);
    if (scoreViewModel.quizModel == null ||
        (scoreViewModel.quizModel != null &&
            scoreViewModel.quizModel?.quizCode != widget.quizCode)) {
      scoreViewModel.getQuizResult(widget.quizCode);
    }
    scoreViewModel.getTopperList(widget.quizCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          ScoreBoardAppHeader(),
          UserOwnResult(),
          // ResultGraphicalView(),
          ToppersList()
        ],
      ),
    ));
  }
}
