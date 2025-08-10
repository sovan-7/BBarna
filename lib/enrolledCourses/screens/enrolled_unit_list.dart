// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/courseSection/viewModel/unit_viewmodel.dart';
import 'package:b_barna_app/courseSection/widgets/course_card.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';

class EnrolledUnitList extends StatefulWidget {
  String? subjectName;
  List<String>? unitCodeList;
  EnrolledUnitList(
      {required this.unitCodeList, required this.subjectName, super.key});

  @override
  State<EnrolledUnitList> createState() => _UnitListState();
}

class _UnitListState extends State<EnrolledUnitList> {
  ScrollController scrollController = ScrollController();
  UnitViewModel unitViewModel = UnitViewModel();
  @override
  void initState() {
    unitViewModel = Provider.of<UnitViewModel>(context, listen: false);
    unitViewModel.getUnitListByUnitCode(widget.unitCodeList ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<UnitViewModel>(
            builder: (context, unitDataProvider, child) {
          return Column(
            children: [
              AppHeader(shouldLanguageIconVisible: false, isBackVisible: true),
              Expanded(
                  child: unitDataProvider.unitListByUnitCode.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            unitDataProvider.getUnitListByUnitCode(
                                widget.unitCodeList ?? []);
                          },
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // number of items in each row
                                    mainAxisSpacing:
                                        8.0, // spacing between rows
                                    crossAxisSpacing: 8.0,
                                    mainAxisExtent:
                                        230 // spacing between columns
                                    ),
                            controller: scrollController,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.all(
                                8.0), // padding around the grid
                            itemCount:
                                unitDataProvider.unitListByUnitCode.length,
                            //itemList.length, // total number of items
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  sp?.setBoolToPref(
                                      SPKeys.canTopicAccess, true);
                                  Navigator.pushNamed(
                                      context, RouteName.topicList,
                                      arguments: {
                                        "unitCode": unitDataProvider
                                            .unitListByUnitCode[index].code,
                                        "unitName": unitDataProvider
                                            .unitListByUnitCode[index].name
                                      });
                                },
                                child: CourseCard(
                                    courseImage: unitDataProvider
                                        .unitListByUnitCode[index].image,
                                    courseText: unitDataProvider
                                        .unitListByUnitCode[index].name,
                                    isUpperStackCardVisible: false),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: TextViewBold(
                            textContent: "No Data Found",
                            textSizeNumber: 16,
                            textColor: Colors.black,
                            maxLines: 3,
                          ),
                        )),
            ],
          );
        }),
      ),
    );
  }
}
