import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/app_button.dart';

class CategoryPicker extends StatefulWidget {
  final PickerModel picker;

  const CategoryPicker({
    Key? key,
    required this.picker,
  }) : super(key: key);

  @override
  _CategoryPickerState createState() {
    return _CategoryPickerState();
  }
}

class _CategoryPickerState extends State<CategoryPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onApply() {
    Navigator.pop(context, widget.picker.selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.picker.title!),
        actions: <Widget>[
          AppButton(
            Translate.of(context).translate('apply'),
            onPressed: onApply,
            type: ButtonType.text,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.picker.data.map((item) {
              final selected = widget.picker.selected.contains(item);
              return SizedBox(
                height: 32,
                child: FilterChip(
                  selected: selected,
                  label: Text(item.title),
                  onSelected: (value) {
                    if (value) {
                      widget.picker.selected.add(item);
                    } else {
                      widget.picker.selected.remove(item);
                    }
                    setState(() {});
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
