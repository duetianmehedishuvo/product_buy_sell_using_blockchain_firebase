import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({this.onTap, this.child, Key? key}) : super(key: key);
  final Function? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onTap!();
      },
      child: child,
    );
  }
}
