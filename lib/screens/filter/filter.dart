import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/repository/repository.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

enum TimeType { start, end }

class Filter extends StatefulWidget {
  final FilterModel filter;
  const Filter({Key? key, required this.filter}) : super(key: key);

  @override
  _FilterState createState() {
    return _FilterState();
  }
}

class _FilterState extends State<Filter> {
  late FilterModel _filter;

  bool _loadingCity = false;
  bool _loadingState = false;
  List<CategoryModel> _listCity = [];
  List<CategoryModel> _listState = [];

  @override
  void initState() {
    super.initState();
    _filter = widget.filter;
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Export String hour
  String _labelTime(TimeOfDay time) {
    final hourLabel = time.hour < 10 ? '0${time.hour}' : '${time.hour}';
    final minLabel = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
    return '$hourLabel:$minLabel';
  }

  ///Show Picker Time
  Future<void> _showTimePicker(BuildContext context, TimeType type) async {
    final picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (type == TimeType.start && picked != null) {
      setState(() {
        _filter.startHour = picked;
      });
    }
    if (type == TimeType.end && picked != null) {
      setState(() {
        _filter.endHour = picked;
      });
    }
  }

  ///On Filter Country
  void _onChangeCountry() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_country'),
        selected: [_filter.country],
        data: Application.setting.locations,
      ),
    );
    if (selected != null && selected is CategoryModel) {
      setState(() {
        _filter.country = selected;
        _filter.city = null;
        _filter.state = null;
        _loadingCity = true;
      });
      final result = await CategoryRepository.loadLocation(selected.id);
      if (result != null) {
        setState(() {
          _listCity = result;
          _loadingCity = false;
        });
      }
    }
  }

  ///On Filter City
  void _onChangeCity() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_city'),
        selected: [_filter.city],
        data: _listCity,
      ),
    );
    if (selected != null && selected is CategoryModel) {
      setState(() {
        _filter.city = selected;
        _filter.state = null;
        _loadingState = true;
      });
      final result = await CategoryRepository.loadLocation(selected.id);
      if (result != null) {
        setState(() {
          _listState = result;
          _loadingState = false;
        });
      }
    }
  }

  ///On Filter State
  void _onChangeState() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_state'),
        selected: [_filter.state],
        data: _listState,
      ),
    );
    if (selected != null && selected is CategoryModel) {
      setState(() {
        _filter.state = selected;
      });
    }
  }

  ///Apply filter
  void _onApply() {
    Navigator.pop(context, _filter);
  }

  ///Build content
  Widget _buildContent() {
    String unit = Application.setting.unit;
    Widget country = Text(
      Translate.of(context).translate('choose_country'),
      style: Theme.of(context).textTheme.bodySmall,
    );
    Widget city = Text(
      Translate.of(context).translate('choose_city'),
      style: Theme.of(context).textTheme.bodySmall,
    );
    Widget state = Text(
      Translate.of(context).translate('choose_state'),
      style: Theme.of(context).textTheme.bodySmall,
    );
    Widget cityAction = RotatedBox(
      quarterTurns: AppLanguage.isRTL() ? 2 : 0,
      child: const Icon(
        Icons.keyboard_arrow_right,
        textDirection: TextDirection.ltr,
      ),
    );
    Widget stateAction = RotatedBox(
      quarterTurns: AppLanguage.isRTL() ? 2 : 0,
      child: const Icon(
        Icons.keyboard_arrow_right,
        textDirection: TextDirection.ltr,
      ),
    );

    if (_filter.country != null) {
      country = Text(
        _filter.country!.title,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Theme.of(context).primaryColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    if (_filter.city != null) {
      city = Text(
        _filter.city!.title,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Theme.of(context).primaryColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    if (_filter.state != null) {
      state = Text(
        _filter.state!.title,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Theme.of(context).primaryColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (_loadingCity) {
      cityAction = const Padding(
        padding: EdgeInsets.only(right: 8),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      );
    }

    if (_loadingState) {
      stateAction = const Padding(
        padding: EdgeInsets.only(right: 8),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Translate.of(context).translate('category'),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Application.setting.category.map((item) {
                final selected = _filter.categories.contains(item);
                return SizedBox(
                  height: 32,
                  child: FilterChip(
                    selected: selected,
                    label: Text(item.title),
                    onSelected: (check) {
                      if (check) {
                        _filter.categories.add(item);
                      } else {
                        _filter.categories.remove(item);
                      }
                      setState(() {});
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('facilities'),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Application.setting.features.map((item) {
                final selected = _filter.features.contains(item);
                return SizedBox(
                  height: 32,
                  child: FilterChip(
                    selected: selected,
                    label: Text(item.title),
                    onSelected: (check) {
                      if (check) {
                        _filter.features.add(item);
                      } else {
                        _filter.features.remove(item);
                      }
                      setState(() {});
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _onChangeCountry,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('country'),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        country,
                      ],
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: _filter.country != null,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _onChangeCity,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Translate.of(context).translate('city'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              city,
                            ],
                          ),
                        ),
                        cityAction,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _filter.city != null,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _onChangeState,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Translate.of(context).translate('state'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              state,
                            ],
                          ),
                        ),
                        stateAction,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Translate.of(context).translate('distance'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '0Km',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '30Km',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
                Slider(
                  value: widget.filter.distance ?? 0,
                  max: 30,
                  min: 0,
                  divisions: 2,
                  label: '${widget.filter.distance ?? 0}',
                  onChanged: (value) {
                    setState(() {
                      widget.filter.distance = value;
                    });
                  },
                ),
                Text(
                  Translate.of(context).translate('price_range'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${Application.setting.minPrice}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${Application.setting.maxPrice}',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 16,
              child: RangeSlider(
                min: Application.setting.minPrice,
                max: Application.setting.maxPrice,
                values: RangeValues(
                  widget.filter.minPrice ?? Application.setting.minPrice,
                  widget.filter.maxPrice ?? Application.setting.maxPrice,
                ),
                onChanged: (range) {
                  setState(() {
                    widget.filter.minPrice = range.start;
                    widget.filter.maxPrice = range.end;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  Translate.of(context).translate('avg_price'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${widget.filter.minPrice?.toInt() ?? Application.setting.minPrice} $unit- ${widget.filter.maxPrice?.toInt() ?? Application.setting.maxPrice} $unit',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
            const SizedBox(height: 16),
            // Text(
            //   Translate.of(context).translate('business_color'),
            //   style: Theme.of(context)
            //       .textTheme
            //       .headlineSmall!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: Application.setting.color.map((item) {
                Widget checked = Container();
                if (_filter.color == item) {
                  checked = const Icon(
                    Icons.check,
                    color: Colors.white,
                  );
                }
                return InkWell(
                  onTap: () {
                    setState(() {
                      _filter.color = item;
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: UtilColor.getColorFromHex(item),
                    ),
                    child: checked,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Text(
            //   Translate.of(context).translate('open_time'),
            //   style: Theme.of(context)
            //       .textTheme
            //       .headlineSmall!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _showTimePicker(context, TimeType.start);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Translate.of(context).translate(
                                'start_time',
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _labelTime(_filter.startHour!),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _showTimePicker(context, TimeType.end);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Translate.of(context).translate(
                                'end_time',
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _labelTime(_filter.endHour!),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('filter'),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('apply'),
            onPressed: _onApply,
            type: ButtonType.text,
          )
        ],
      ),
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }
}
