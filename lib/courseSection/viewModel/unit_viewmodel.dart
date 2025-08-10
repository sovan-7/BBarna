import 'package:flutter/foundation.dart';
import 'package:b_barna_app/courseSection/model/unit_model.dart';
import 'package:b_barna_app/courseSection/repo/unit_repo.dart';
import 'package:b_barna_app/utils/helper.dart';

class UnitViewModel extends ChangeNotifier {
  final UnitRepo _unitRepo = UnitRepo();
  List<UnitModel> unitList = [];
  List<UnitModel> unitListByUnitCode = [];

  Future getUnitList(String subjectCode) async {
    try {
      unitList.clear();
      unitList = await _unitRepo.getUnitList(subjectCode);
      unitList.sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      notifyListeners();
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  Future getUnitListByUnitCode(List<String> unitCodeList) async {
    try {
      unitListByUnitCode.clear();
      unitListByUnitCode = await _unitRepo.getUnitListById(unitCodeList);
      unitListByUnitCode
          .sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
      notifyListeners();
    } catch (e) {
      // Helper.showSnackBarMessage(
      //     msg: "Error while fetching data", isSuccess: false);
    }
  }
}
