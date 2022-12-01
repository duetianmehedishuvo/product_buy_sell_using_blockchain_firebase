import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/helpers/color.dart';
import 'package:product_buy_sell/widgets/rounded_button.dart';

IconData? backIcon(BuildContext context) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
      return Icons.arrow_back;
    case TargetPlatform.iOS:
      return Icons.arrow_back_ios;
    case TargetPlatform.linux:
      // TODO: Handle this case.
      break;
    case TargetPlatform.macOS:
      // TODO: Handle this case.
      break;
    case TargetPlatform.windows:
      // TODO: Handle this case.
      break;
  }
  assert(false);
  return null;
}

IconData? rightIcon(BuildContext context) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
      return CupertinoIcons.arrowshape_turn_up_right;
    case TargetPlatform.iOS:
      return Icons.arrow_forward_ios;
    case TargetPlatform.linux:
      // TODO: Handle this case.
      break;
    case TargetPlatform.macOS:
      // TODO: Handle this case.
      break;
    case TargetPlatform.windows:
      // TODO: Handle this case.
      break;
  }
  assert(false);
  return null;
}

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? btnTxt;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final bool? isStroked;
  final bool? isShowRightIcon;
  final bool? isShowLeftIcon;
  final double? fontSize;
  final double? radius;
  final bool? textWhiteColor;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;

  const CustomButton(
      {this.onTap,
      @required this.btnTxt,
      this.backgroundColor = kSecondaryColor,
      this.textColor = Colors.white,
      this.height = 45.0,
      this.fontSize = 14.0,
      this.isStroked = false,
      this.isShowRightIcon = false,
      this.isShowLeftIcon = false,
      this.textWhiteColor = false,
      this.radius = 9.0,
      this.leftPadding = 0,
      this.rightPadding = 0,
      this.topPadding = 0,
      this.bottomPadding = 0,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      padding: 0,
      onPress: onTap,
      backgroundColor: MaterialStateProperty.all(backgroundColor!),
      boarderRadius: radius!,
      child: Container(
        height: height,
        padding: EdgeInsets.fromLTRB(leftPadding!, topPadding!, rightPadding!, bottomPadding!),
        alignment: Alignment.center,
        child: Text(btnTxt!, style: TextStyle(color: textColor, fontSize: fontSize), textAlign: TextAlign.center),
      ),
    );
  }
}

class IconButton1 extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const IconButton1(
      {required this.onTap, required this.icon, this.width = 43, this.height = 43, this.backgroundColor = Colors.red, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: backgroundColor!.withOpacity(.05), offset: const Offset(0, 0), blurRadius: 20, spreadRadius: 3)]),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor, boxShadow: [
            BoxShadow(color: backgroundColor!.withOpacity(.05), offset: const Offset(0, 0), blurRadius: 20, spreadRadius: 3)
          ]),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
