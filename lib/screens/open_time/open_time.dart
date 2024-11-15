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
    return Container();
  }
}
