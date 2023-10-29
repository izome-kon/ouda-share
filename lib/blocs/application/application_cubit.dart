import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/api/api.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationState.loading);

  ///On Setup Application
  void onSetup() async {
    ///Get old Theme & Font & Language & Dark Mode & Domain
    await Preferences.setPreferences();

    final oldTheme = Preferences.getString(Preferences.theme);
    final oldFont = Preferences.getString(Preferences.font);
    final oldLanguage = Preferences.getString(Preferences.language);
    final oldDarkOption = Preferences.getString(Preferences.darkOption);
    final oldDomain = Preferences.getString(Preferences.domain);
    final oldTextScale = Preferences.getDouble(Preferences.textScaleFactor);
    final oldSetting = Preferences.getString(Preferences.setting);

    DarkOption? darkOption;
    String? font;
    ThemeModel? theme;

    ///Setup domain
    if (oldDomain != null) {
      Application.domain = oldDomain;
    }

    ///Setup Language
    if (oldLanguage != null) {
      AppBloc.languageCubit.onUpdate(Locale(oldLanguage));
    }

    ///Find font support available [Dart null safety issue]
    try {
      font = AppTheme.fontSupport.firstWhere((item) {
        return item == oldFont;
      });
    } catch (e) {
      UtilLogger.log("ERROR", e);
    }

    ///Setup theme
    if (oldTheme != null) {
      theme = ThemeModel.fromJson(jsonDecode(oldTheme));
    }

    ///check old dark option
    if (oldDarkOption != null) {
      switch (oldDarkOption) {
        case 'off':
          darkOption = DarkOption.alwaysOff;
          break;
        case 'on':
          darkOption = DarkOption.alwaysOn;
          break;
        default:
          darkOption = DarkOption.dynamic;
      }
    }

    ///Setup application & setting
    final results = await Future.wait([
      PackageInfo.fromPlatform(),
      Utils.getDeviceInfo(),
      Firebase.initializeApp(),
    ]);

    Application.packageInfo = results[0] as PackageInfo;
    Application.device = results[1] as DeviceModel;

    ///setup setting
    if (oldSetting != null) {
      Application.setting = SettingModel.fromJson(jsonDecode(oldSetting));
    }
    Api.requestSetting().then((response) {
      if (response.success) {
        Preferences.setString(Preferences.setting, jsonEncode(response.data));
        Application.setting = SettingModel.fromJson(response.data);
      }
    });

    ///Setup Theme & Font with dark Option
    AppBloc.themeCubit.onChangeTheme(
      theme: theme,
      font: font,
      darkOption: darkOption,
      textScaleFactor: oldTextScale,
    );

    ///Authentication begin check
    AppBloc.authenticateCubit.onCheck();

    ///First or After upgrade version show intro preview app
    final hasReview = Preferences.containsKey(
      '${Preferences.reviewIntro}.${Application.packageInfo?.version}',
    );
    if (hasReview) {
      ///Notify
      emit(ApplicationState.completed);
    } else {
      ///Notify
      emit(ApplicationState.intro);
    }
  }

  ///On Complete Intro
  void onCompletedIntro() async {
    await Preferences.setBool(
      '${Preferences.reviewIntro}.${Application.packageInfo?.version}',
      true,
    );

    ///Notify
    emit(ApplicationState.completed);
  }

  ///On Change Domain
  void onChangeDomain(String domain) async {
    emit(ApplicationState.loading);
    final isDomain = Uri.tryParse(domain);
    if (isDomain != null) {
      Application.domain = domain;
      Api.httpManager.changeDomain(domain);
      await Preferences.setString(
        Preferences.domain,
        domain,
      );
      await Future.delayed(const Duration(milliseconds: 250));
      AppBloc.authenticateCubit.onClear();
      emit(ApplicationState.completed);
    } else {
      AppBloc.messageCubit.onShow('domain_not_correct');
    }
  }
}
