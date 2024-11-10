import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() {
    return _SettingState();
  }
}

class _SettingState extends State<Setting> {
  bool _receiveNotification = true;
  DarkOption _darkOption = AppBloc.themeCubit.state.darkOption;
  String? _errorDomain;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On Change Dark Option
  void _onChangeDarkOption() {
    AppBloc.themeCubit.onChangeTheme(darkOption: _darkOption);
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  ///Show dark theme setting
  void _onDarkModeSetting() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        _darkOption = AppBloc.themeCubit.state.darkOption;
        return AlertDialog(
          title: Text(Translate.of(context).translate('dark_mode')),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    RadioListTile<DarkOption>(
                      title: Text(
                        Translate.of(context).translate(
                          AppTheme.langDarkOption(DarkOption.dynamic),
                        ),
                      ),
                      activeColor: Theme.of(context).primaryColor,
                      value: DarkOption.dynamic,
                      groupValue: _darkOption,
                      onChanged: (value) {
                        setState(() {
                          _darkOption = DarkOption.dynamic;
                        });
                      },
                    ),
                    RadioListTile<DarkOption>(
                      title: Text(
                        Translate.of(context).translate(
                          AppTheme.langDarkOption(DarkOption.alwaysOn),
                        ),
                      ),
                      activeColor: Theme.of(context).primaryColor,
                      value: DarkOption.alwaysOn,
                      groupValue: _darkOption,
                      onChanged: (value) {
                        setState(() {
                          _darkOption = DarkOption.alwaysOn;
                        });
                      },
                    ),
                    RadioListTile<DarkOption>(
                      title: Text(
                        Translate.of(context).translate(
                          AppTheme.langDarkOption(DarkOption.alwaysOff),
                        ),
                      ),
                      activeColor: Theme.of(context).primaryColor,
                      value: DarkOption.alwaysOff,
                      groupValue: _darkOption,
                      onChanged: (value) {
                        setState(() {
                          _darkOption = DarkOption.alwaysOff;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.pop(context, false);
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('apply'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    if (result == true) {
      _onChangeDarkOption();
    } else {
      _darkOption = AppBloc.themeCubit.state.darkOption;
    }
  }

  ///On Change Domain
  void _onChangeDomain() async {
    final result = await showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final textNameController = TextEditingController(
          text: Application.domain,
        );
        return AlertDialog(
          title: Text(Translate.of(context).translate('change_domain')),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AppTextInput(
                      hintText: Translate.of(context).translate('input_domain'),
                      errorText: _errorDomain,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        setState(() {
                          _errorDomain = UtilValidator.validate(
                            textNameController.text,
                          );
                        });
                      },
                      controller: textNameController,
                    )
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.pop(context);
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('apply'),
              onPressed: () {
                Navigator.pop(context, textNameController.text);
              },
            ),
          ],
        );
      },
    );
    if (result != null) {
      if (!mounted) return;
      Navigator.popUntil(
        context,
        ModalRoute.withName(Navigator.defaultRouteName),
      );
      AppBloc.applicationCubit.onChangeDomain(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('setting'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            AppListTitle(
              title: Translate.of(context).translate('language'),
              onPressed: () {
                _onNavigate(Routes.changeLanguage);
              },
              trailing: Row(
                children: <Widget>[
                  Text(
                    AppLanguage.getGlobalLanguageName(
                      AppBloc.languageCubit.state.languageCode,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  RotatedBox(
                    quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
            AppListTitle(
              title: Translate.of(context).translate('notification'),
              trailing: CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                value: _receiveNotification,
                onChanged: (value) {
                  setState(() {
                    _receiveNotification = value;
                  });
                },
              ),
            ),
            AppListTitle(
              title: Translate.of(context).translate('theme'),
              onPressed: () {
                _onNavigate(Routes.themeSetting);
              },
              trailing: Container(
                margin: const EdgeInsets.only(right: 8),
                width: 16,
                height: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            AppListTitle(
              title: Translate.of(context).translate('dark_mode'),
              onPressed: _onDarkModeSetting,
              trailing: Row(
                children: <Widget>[
                  Text(
                    Translate.of(context).translate(
                      AppTheme.langDarkOption(
                        AppBloc.themeCubit.state.darkOption,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  RotatedBox(
                    quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
            AppListTitle(
              title: Translate.of(context).translate('font'),
              onPressed: () {
                _onNavigate(Routes.fontSetting);
              },
              trailing: Row(
                children: <Widget>[
                  Text(
                    AppBloc.themeCubit.state.font,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  RotatedBox(
                    quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
            AppListTitle(
              title: Translate.of(context).translate('domain'),
              onPressed: _onChangeDomain,
              trailing: Row(
                children: <Widget>[
                  Text(
                    Application.domain,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  RotatedBox(
                    quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
            AppListTitle(
              title: Translate.of(context).translate('version'),
              onPressed: () {},
              trailing: Row(
                children: <Widget>[
                  Text(
                    Application.packageInfo?.version ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  RotatedBox(
                    quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
              border: false,
            ),
          ],
        ),
      ),
    );
  }
}
