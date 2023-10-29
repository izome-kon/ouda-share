import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class FontSetting extends StatefulWidget {
  const FontSetting({Key? key}) : super(key: key);

  @override
  _FontSettingState createState() {
    return _FontSettingState();
  }
}

class _FontSettingState extends State<FontSetting> {
  String? _currentFont = AppBloc.themeCubit.state.font;
  double _currentScale = AppBloc.themeCubit.state.textScaleFactor! * 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On change Font
  void _onChange() {
    AppBloc.themeCubit.onChangeTheme(
      font: _currentFont,
      textScaleFactor: _currentScale / 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  title: Text(
                    Translate.of(context).translate('font'),
                  ),
                  actions: [
                    AppButton(
                      Translate.of(context).translate('apply'),
                      onPressed: _onChange,
                      type: ButtonType.text,
                    ),
                  ],
                  pinned: true,
                ),
                SliverSafeArea(
                  top: false,
                  sliver: SliverPadding(
                    padding: const EdgeInsets.only(top: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Widget? trailing;
                          final item = AppTheme.fontSupport[index];
                          if (item == _currentFont) {
                            trailing = Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            );
                          }
                          return AppListTitle(
                            title: item,
                            trailing: trailing,
                            border: item != AppTheme.fontSupport.last,
                            onPressed: () {
                              setState(() {
                                _currentFont = item;
                              });
                            },
                          );
                        },
                        childCount: AppTheme.fontSupport.length,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.sort_by_alpha_outlined,
                    size: 20,
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentScale,
                      max: 140,
                      min: 80,
                      divisions: 10,
                      label: _currentScale.toString(),
                      onChanged: (value) {
                        setState(() {
                          _currentScale = value;
                        });
                      },
                    ),
                  ),
                  const Icon(
                    Icons.sort_by_alpha_outlined,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
