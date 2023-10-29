import 'package:flutter/material.dart';

class AppLanguage {
  ///Default Language
  static const Locale defaultLanguage = Locale("en");

  ///List Language support in Application
  static final List<Locale> supportLanguage = [
    const Locale("en"),
    const Locale("vi"),
    const Locale("ar"),
    const Locale("da"),
    const Locale("de"),
    const Locale("el"),
    const Locale("fr"),
    const Locale("he"),
    const Locale("id"),
    const Locale("ja"),
    const Locale("ko"),
    const Locale("lo"),
    const Locale("nl"),
    const Locale("zh"),
    const Locale("fa"),
    const Locale("km"),
    const Locale("pt"),
    const Locale("ru"),
    const Locale("tr"),
    const Locale("hi"),
    const Locale("es"),
  ];

  ///Get Language Global Language Name
  static String getGlobalLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Vietnamese';
      case 'ar':
        return 'Arabic';
      case 'da':
        return 'Danish';
      case 'de':
        return 'German';
      case 'el':
        return 'Greek';
      case 'fr':
        return 'French';
      case 'he':
        return 'Hebrew';
      case 'id':
        return 'Indonesian';
      case 'ja':
        return 'Japanese';
      case 'ko':
        return 'Korean';
      case 'lo':
        return 'Lao';
      case 'nl':
        return 'Dutch';
      case 'zh':
        return 'Chinese';
      case 'fa':
        return 'Iran';
      case 'km':
        return 'Cambodian';
      case 'pt':
        return 'Brazilian - Portuguese';
      case 'ru':
        return 'Russian';
      case 'tr':
        return 'Turkish';
      case 'hi':
        return 'Indian';
      case 'es':
        return 'Spanish';

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
