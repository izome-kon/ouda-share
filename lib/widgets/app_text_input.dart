import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class AppTextInput extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final int? maxLines;
  final bool? autofocus;

  const AppTextInput({
    Key? key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.trailing,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.maxLines = 1,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  Widget _buildErrorLabel(BuildContext context) {
    if (widget.errorText == null) {
      return Container();
    }
    if (widget.leading != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                Translate.of(context).translate(widget.errorText!),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.error),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              Translate.of(context).translate(widget.errorText!),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.error),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget = const SizedBox(width: 16);
    Widget deleteAction = Container();

    if (widget.leading != null) {
      leadingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          widget.leading!,
          const SizedBox(width: 8),
        ],
      );
    }

    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      deleteAction = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {
              widget.controller!.clear();
              if (widget.onChanged != null) {
                setState(() {
                  widget.onChanged!(widget.controller!.text);
                });
              }
            },
            child: const Icon(Icons.clear),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withOpacity(.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Row(
            children: [
              leadingWidget,
              Expanded(
                child: TextField(
                  onTap: widget.onTap,
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: widget.onSubmitted,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  onChanged: widget.onChanged,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  maxLines: widget.maxLines,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.trailing ?? Container(),
                        deleteAction,
                        const SizedBox(width: 12)
                      ],
                    ),
                    border: InputBorder.none,
                  ),
                  autofocus: widget.autofocus ?? false,
                ),
              )
            ],
          ),
          _buildErrorLabel(context)
        ],
      ),
    );
  }
}
