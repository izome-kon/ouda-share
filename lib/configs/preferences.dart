import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? instance;

  static const String domain = 'domain';
  static const String reviewIntro = 'review';
  static const String user = 'user';
  static const String language = 'language';
  static const String notification = 'notification';
  static const String theme = 'theme';
  static const String textScaleFactor = 'textScaleFactor';
  static const String darkOption = 'darkOption';
  static const String font = 'font';
  static const String setting = 'setting';
  static const String search = 'search';

  static Future<void> setPreferences() async {
    instance = await SharedPreferences.getInstance();
  }

  static Future<bool> clear() {
    return Preferences.instance!.clear();
  }

  static bool containsKey(String key) {
    return Preferences.instance!.containsKey(key);
  }

  static dynamic get(String key) {
    return Preferences.instance!.get(key);
  }

  static bool? getBool(String key) {
    return Preferences.instance!.getBool(key);
  }

  static double? getDouble(String key) {
    return Preferences.instance!.getDouble(key);
  }

  static int? getInt(String key) {
    return Preferences.instance!.getInt(key);
  }

  static Set<String> getKeys() {
    return Preferences.instance!.getKeys();
  }

  static String? getString(String key) {
    return Preferences.instance!.getString(key);
  }

  static List<String>? getStringList(String key) {
    return Preferences.instance!.getStringList(key);
  }

  static Future<void> reload() {
    return Preferences.instance!.reload();
  }

  static Future<bool> remove(String key) {
    return Preferences.instance!.remove(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return Preferences.instance!.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return Preferences.instance!.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return Preferences.instance!.setInt(key, value);
  }

  static Future<bool> setString(String key, String value) {
    return Preferences.instance!.setString(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return Preferences.instance!.setStringList(key, value);
  }

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
