import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final double padding;
  final double boarderRadius;
  final Widget? child;
  final VoidCallback? onPress;
  final MaterialStateProperty<Color>? backgroundColor;

  const RoundedButton({this.padding = 12.0, this.boarderRadius = 8.0, this.child, this.onPress, this.backgroundColor, key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
        backgroundColor: backgroundColor,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(boarderRadius),
        )),
      ),
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
