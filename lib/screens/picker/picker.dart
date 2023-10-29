import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class Picker extends StatefulWidget {
  final PickerModel picker;

  const Picker({
    Key? key,
    required this.picker,
  }) : super(key: key);

  @override
  _PickerState createState() {
    return _PickerState();
  }
}

class _PickerState extends State<Picker> {
  final _textPickerController = TextEditingController();

  String _keyword = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textPickerController.dispose();
    super.dispose();
  }

  ///On Filter Location
  void _onFilter(String text) {
    setState(() {
      _keyword = text;
    });
  }

  ///Build List
  Widget _buildList() {
    if (widget.picker.data.isEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.sentiment_satisfied),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                Translate.of(context).translate(
                  'can_not_found_data',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      );
    }

    List data = widget.picker.data;

    ///Filter
    if (_keyword.isNotEmpty) {
      data = data.where(((item) {
        return item.title.toUpperCase().contains(_keyword.toUpperCase());
      })).toList();
    }

    ///Build List
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppTextInput(
            hintText: Translate.of(context).translate('search'),
            onChanged: _onFilter,
            onSubmitted: _onFilter,
            controller: _textPickerController,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = data[index];
              Widget? leading;
              Widget? trailing;
              if (item.icon != null && item.icon is Widget) {
                leading = item.icon;
              }
              if (widget.picker.selected.contains(item)) {
                trailing = Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                );
              }

              return AppListTitle(
                title: item.title,
                leading: leading,
                trailing: trailing,
                border: index != data.length - 1,
                onPressed: () {
                  Navigator.pop(context, item);
                },
              );
            },
            itemCount: data.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.picker.title ?? 'title',
        ),
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }
}
