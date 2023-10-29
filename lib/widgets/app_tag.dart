import 'package:flutter/material.dart';

enum TagType { status, chip, rate }

class AppTag extends StatelessWidget {
  const AppTag(
    this.text, {
    Key? key,
    required this.type,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final TagType type;
  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container();
    if (icon != null) {
      iconWidget = Row(
        children: [icon!, const SizedBox(width: 8)],
      );
    }
    switch (type) {
      case TagType.rate:
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );

      case TagType.status:
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white),
            ),
          ),
        );

      case TagType.chip:
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              color: Theme.of(context).dividerColor.withOpacity(0.07),
            ),
            child: Row(
              children: <Widget>[
                iconWidget,
                Text(
                  text,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                )
              ],
            ),
          ),
        );

      default:
        return InkWell(
          onTap: onPressed,
          child: Container(),
        );
    }
  }
}
