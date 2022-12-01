import 'package:product_buy_sell/localization/language_constrants.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:flutter/material.dart';

class CustomText2 extends StatelessWidget {
  const CustomText2(
      {this.title,
      this.color = Colors.white,
      this.fontSize = 14,
      this.fontWeight,
      this.fontStyle,
      this.textAlign,
      this.decoration,
      this.maxLines = 1,
      this.height,
      this.overflow,
      this.textStyle,
      Key? key})
      : super(key: key);
  final String? title;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final int? maxLines;
  final double? height;
  final TextOverflow? overflow;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      getTranslated(title!, context) ?? "",
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow,
      style: textStyle ??
          sfProStyle400Regular.copyWith(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            decoration: decoration,
            fontStyle: fontStyle,
            height: height,
          ),
    );
  }
}
