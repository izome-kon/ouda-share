import 'package:flutter/material.dart';

enum ButtonType { normal, outline, text }

enum ButtonSize { large, small }

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool loading;
  final bool disabled;
  final ButtonType type;
  final Widget? icon;
  final MainAxisSize mainAxisSize;
  final ButtonSize size;

  const AppButton(
    this.text, {
    Key? key,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.type = ButtonType.normal,
    this.mainAxisSize = MainAxisSize.min,
    this.size = ButtonSize.large,
  }) : super(key: key);

  Widget _buildLoading(BuildContext context) {
    if (!loading) return Container();
    return Row(
      children: [
        const SizedBox(width: 8),
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Theme.of(context).colorScheme.secondary,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size buttonSize = const Size(64, 48);
    if (size == ButtonSize.small) {
      buttonSize = const Size(64, 36);
    }
    switch (type) {
      case ButtonType.outline:
        if (icon != null) {
          return OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: buttonSize,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: Row(
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                _buildLoading(context)
              ],
            ),
          );
        }
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: buttonSize,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: disabled ? null : onPressed,
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              _buildLoading(context)
            ],
          ),
        );

      case ButtonType.text:
        if (icon != null) {
          return TextButton.icon(
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: Row(
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                _buildLoading(context)
              ],
            ),
          );
        }
        return TextButton(
          onPressed: disabled ? null : onPressed,
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              _buildLoading(context)
            ],
          ),
        );
      default:
        if (icon != null) {
          return ElevatedButton.icon(
            onPressed: disabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: buttonSize,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: icon!,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                _buildLoading(context)
              ],
            ),
          );
        }
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: buttonSize,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              _buildLoading(context)
            ],
          ),
        );
    }
  }
}
