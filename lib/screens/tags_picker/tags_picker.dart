import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/repository/repository.dart';
import 'package:listar_flutter_pro/utils/translate.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class TagsPicker extends StatefulWidget {
  final List<String> selected;

  const TagsPicker({Key? key, required this.selected}) : super(key: key);

  @override
  _TagsPickerState createState() {
    return _TagsPickerState();
  }
}

class _TagsPickerState extends State<TagsPicker> {
  final _textEditController = TextEditingController();

  List<String> _tags = [];
  List<String> _suggest = [];
  Timer? _debounce;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _tags = widget.selected;
    _textEditController.text = _tags.join(",");
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  ///On change text
  void _onChange(String keyword) {
    _debounce?.cancel();
    if (keyword.isNotEmpty) {
      final arrList = keyword.split(",");
      setState(() {
        _searching = true;
      });
      _debounce = Timer(const Duration(seconds: 1), () async {
        final result = await ListRepository.loadTags(arrList.last);
        if (mounted) {
          setState(() {
            _tags = arrList;
            _searching = false;
            _suggest = result!;
          });
        }
      });
    } else {
      setState(() {
        _tags.clear();
        _searching = false;
        _suggest = [];
      });
    }
  }

  ///On completed
  void _onCompleted(String item) {
    final arrList = _textEditController.text.split(",");
    arrList.last = item;
    _textEditController.text = arrList.join(",");
    _textEditController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textEditController.text.length),
    );
    setState(() {
      _tags = arrList;
    });
  }

  ///On completed
  void _onRemove(String item) {
    setState(() {
      _tags.remove(item);
    });
    _textEditController.text = _tags.join(",");
    _textEditController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textEditController.text.length),
    );
  }

  ///On apply
  void _onApply() {
    Navigator.pop(context, _tags);
  }

  @override
  Widget build(BuildContext context) {
    Widget? trailing;
    if (_searching) {
      trailing = const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('choose_tags'),
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
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextInput(
                hintText: Translate.of(context).translate('input_tags'),
                controller: _textEditController,
                onChanged: _onChange,
                onSubmitted: _onChange,
                trailing: trailing,
                autofocus: true,
              ),
              const SizedBox(height: 2),
              Text(
                Translate.of(context).translate('separate_tag'),
                style: Theme.of(context).textTheme.caption,
              ),
              AnimatedContainer(
                height: _suggest.isNotEmpty ? 88 : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _suggest.map((item) {
                        return SizedBox(
                          height: 32,
                          child: InputChip(
                            avatar: const Icon(Icons.add),
                            label: Text(item),
                            onPressed: () {
                              _onCompleted(item);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((item) {
                    return SizedBox(
                      height: 32,
                      child: InputChip(
                        avatar: const Icon(Icons.highlight_remove),
                        label: Text(item),
                        onPressed: () {
                          _onRemove(item);
                        },
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
