import 'package:flutter/material.dart';

double getAppSizeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getAppSizeWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

class ThemeUtility {
  static const double baseHeight = 812.0;
  static const double baseWidth = 375.0;

  static double screenAwareHeight(double size, BuildContext context) {
    final double drawingHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return size * drawingHeight / baseHeight;
  }

  static double screenAwareWidth(double size, BuildContext context) {
    final double drawingWidth = MediaQuery.of(context).size.width;
    return size * drawingWidth / baseWidth;
  }
}

const kDefaultPadding = 20.0;
