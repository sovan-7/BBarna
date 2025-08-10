// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:b_barna_app/core/route/route_name.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/courseSection/viewModel/unit_viewmodel.dart';
import 'package:b_barna_app/courseSection/widgets/course_card.dart';
import 'package:b_barna_app/utils/sp_keys.dart';
import 'package:provider/provider.dart';

class UnitList extends StatefulWidget {
  String? subjectName;
  String? subjectCode;
  UnitList({required this.subjectCode, required this.subjectName, super.key});

  @override
  State<UnitList> createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  ScrollController scrollController = ScrollController();
  UnitViewModel unitViewModel = UnitViewModel();
  @override
  void initState() {
    unitViewModel = Provider.of<UnitViewModel>(context, listen: false);
    unitViewModel.getUnitList(widget.subjectCode ?? stringDefault);
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
                  child: RefreshIndicator(
                onRefresh: () async {
                  unitDataProvider
                      .getUnitList(widget.subjectCode ?? stringDefault);
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0,
                      mainAxisExtent: 230 // spacing between columns
                      ),
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(8.0), // padding around the grid
                  itemCount: unitDataProvider.unitList.length,
                  //itemList.length, // total number of items
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (unitDataProvider.unitList[index].name
                                .toLowerCase()
                                .contains("demo") ||
                            sp?.getStringFromPref(SPKeys.phoneNumber) ==
                                "7001739646" ||
                            sp?.getStringFromPref(SPKeys.phoneNumber) ==
                                "7031786668" ||
                            sp?.getStringFromPref(SPKeys.phoneNumber) ==
                                "9733815585" ||
                            sp?.getStringFromPref(SPKeys.phoneNumber) ==
                                "8210703249") {
                          sp?.setBoolToPref(SPKeys.canTopicAccess, true);
                        }
                        Navigator.pushNamed(context, RouteName.topicList,
                            arguments: {
                              "unitCode": unitDataProvider.unitList[index].code,
                              "unitName": unitDataProvider.unitList[index].name
                            }).whenComplete(() {
                          sp?.setBoolToPref(SPKeys.canTopicAccess, false);
                        });
                      },
                      child: CourseCard(
                          courseImage: unitDataProvider.unitList[index].image,
                          courseText: unitDataProvider.unitList[index].name,
                          isUpperStackCardVisible: false),
                    );
                  },
                ),
              )),
            ],
          );
        }),
      ),
    );
  }
}
