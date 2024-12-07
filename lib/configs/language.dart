import 'package:flutter/material.dart';

class AppLanguage {
  ///Default Language
  static const Locale defaultLanguage = Locale("en");

  ///List Language support in Application
  static final List<Locale> supportLanguage = [
    const Locale("en"),
    const Locale("ar"),
  ];

  ///Get Language Global Language Name
  static String getGlobalLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'Arabic';
      default:
        return 'Unknown';
    }
  }

  ///isRTL layout
  static bool isRTL() {
    switch (AppLanguage.defaultLanguage.languageCode) {
      case "ar":
      case "he":
        return true;
      default:
        return false;
    }
  }

  ///Singleton factory
  static final AppLanguage _instance = AppLanguage._internal();

  factory AppLanguage() {
    return _instance;
  }

  AppLanguage._internal();
}
