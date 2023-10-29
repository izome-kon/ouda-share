import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class OpenTime extends StatefulWidget {
  final List<OpenTimeModel>? selected;

  const OpenTime({Key? key, this.selected}) : super(key: key);

  @override
  _OpenTimeState createState() {
    return _OpenTimeState();
  }
}

class _OpenTimeState extends State<OpenTime> {
  final _defaultStartTime = const TimeOfDay(hour: 8, minute: 0);
  final _defaultEndTime = const TimeOfDay(hour: 18, minute: 0);

  List<OpenTimeModel> _time = [];

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      _time = widget.selected!;
    } else {
      _time = [
        OpenTimeModel(dayOfWeek: 1, key: 'mon', schedule: [
          ScheduleModel(
            start: _defaultStartTime,
            end: _defaultEndTime,
          ),
        ]),
        OpenTimeModel(dayOfWeek: 2, key: 'tue', schedule: [
          ScheduleModel(
            start: _defaultStartTime,
            end: _defaultEndTime,
          ),
        ]),
        OpenTimeModel(dayOfWeek: 3, key: 'wed', schedule: [
          ScheduleModel(
            start: _defaultStartTime,
            end: _defaultEndTime,
          ),
        ]),
        OpenTimeModel(dayOfWeek: 4, key: 'thu', schedule: [
          ScheduleModel(
            start: _defaultStartTime,
            end: _defaultEndTime,
          ),
        ]),
        OpenTimeModel(dayOfWeek: 5, key: 'fri', schedule: [
          ScheduleModel(
            start: _defaultStartTime,
            end: _defaultEndTime,
          ),
        ]),
        OpenTimeModel(dayOfWeek: 6, key: 'sat', schedule: [
          ScheduleModel(
            start: _defaultStartTime,
            end: _defaultEndTime,
          ),
        ]),
        OpenTimeModel(dayOfWeek: 7, key: 'sun', schedule: [
          ScheduleModel(
            start: _defaultStartTime,
            end: _defaultEndTime,
          ),
        ]),
      ];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Show Time Time
  void _onTimePicker(TimeOfDay time, Function(TimeOfDay) callback) async {
    final picked = await showTimePicker(
      initialTime: time,
      context: context,
    );

    if (picked != null) {
      callback(picked);
    }
  }

  ///On Save
  void _onSave() {
    Navigator.pop(context, _time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('open_time'),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('apply'),
            onPressed: _onSave,
            type: ButtonType.text,
          )
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final item = _time[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translate.of(context).translate(item.key),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final addAction = index == 0;
                    final element = item.schedule[index];
                    return Row(
                      children: [
                        Expanded(
                          child: AppPickerItem(
                            value: element.start.viewTime,
                            title: Translate.of(context).translate(
                              'choose_hours',
                            ),
                            onPressed: () {
                              _onTimePicker(element.start, (time) {
                                setState(() {
                                  element.start = time;
                                });
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppPickerItem(
                            value: element.end.viewTime,
                            title: Translate.of(context).translate(
                              'choose_hours',
                            ),
                            onPressed: () {
                              _onTimePicker(element.end, (time) {
                                setState(() {
                                  element.end = time;
                                });
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            if (addAction) {
                              item.schedule.add(
                                ScheduleModel(
                                  start: _defaultStartTime,
                                  end: _defaultEndTime,
                                ),
                              );
                            } else {
                              item.schedule.remove(element);
                            }
                            setState(() {});
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(
                              addAction ? Icons.add : Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemCount: item.schedule.length,
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
          itemCount: _time.length,
        ),
      ),
    );
  }
}
