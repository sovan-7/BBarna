import 'package:b_barna_app/core/constants/value_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefOperations {
  late SharedPreferences _prefs;

  static SharedPrefOperations get getInstance => SharedPrefOperations();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setIntToPref(String key, int value) {
    return _prefs.setInt(key, value);
  }

  Future<bool> setBoolToPref(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  Future<bool> setDoubleToPref(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  Future<bool> setStringToPref(String key, String value) {
    return _prefs.setString(key, value);
  }

  Future<bool> setStringListToPref(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  int getIntFromPref(String key) {
    return _prefs.getInt(key) ?? intDefault;
  }

  bool getBoolFromPref(String key) {
    return _prefs.getBool(key) ?? boolDefault;
  }

  double getDoubleFromPref(String key) {
    return _prefs.getDouble(key) ?? doubleDefault;
  }

  String getStringFromPref(String key) {
    return _prefs.getString(key) ?? stringDefault;
  }

  List<String> getStringListFromPref(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  clearPreference() async {
    await _prefs.clear();
  }
}
