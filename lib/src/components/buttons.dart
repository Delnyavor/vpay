import 'package:flutter/material.dart';

ElevatedButton elevatedButton(
  BuildContext context, {
  required String label,
  required Function() function,
  bool shrink = true,
  Widget? icon,
  TextStyle? labelStyle,
  ButtonStyle? buttonStyle,
}) {
  ThemeData theme = Theme.of(context);

  return ElevatedButton(
    onPressed: function,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
      children: [
        icon ?? SizedBox.shrink(),
        Text(
          label,
          style: labelStyle ??
              Theme.of(context).textTheme.button!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
        ),
      ],
    ),
    style: ButtonStyle(
      overlayColor: buttonStyle?.overlayColor ??
          MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered))
                return Colors.blue.withOpacity(0.904);
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed))
                return Colors.blue.withOpacity(0.912);
              //
              return Colors.blue
                  .withOpacity(0.912); // Defer to the widget's default.
            },
          ),
      backgroundColor: buttonStyle?.backgroundColor ??
          MaterialStateProperty.all<Color>(
            theme.primaryColor,
          ),
      padding: buttonStyle?.padding ??
          MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
      shape: buttonStyle?.shape ??
          MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
      elevation: buttonStyle?.elevation ?? MaterialStateProperty.all<double>(4),
    ),
  );
}

TextButton textButton(
  BuildContext context, {
  required String label,
  required Function() function,
  bool shrink = true,
  Widget? icon,
  TextStyle? labelStyle,
  ButtonStyle? buttonStyle,
}) {
  ThemeData theme = Theme.of(context);

  return TextButton(
    onPressed: function,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
      children: [
        icon ?? SizedBox.shrink(),
        Text(
          label,
          style: labelStyle ??
              Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    ),
    style: ButtonStyle(
      overlayColor: buttonStyle?.overlayColor ??
          MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered))
                return Colors.indigoAccent[700]!;
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed))
                return Colors.indigoAccent[700]!;
              return Colors
                  .indigoAccent[700]!; // Defer to the widget's default.
            },
          ),
      backgroundColor: buttonStyle?.backgroundColor ??
          MaterialStateProperty.all<Color>(
            theme.primaryColor,
          ),
      padding: buttonStyle?.padding ??
          MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
      shape: buttonStyle?.shape ??
          MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
      elevation:
          buttonStyle?.elevation ?? MaterialStateProperty.all<double>(0.5),
    ),
  );
}
