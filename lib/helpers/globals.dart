library noter.globals;

import 'package:flutter/material.dart';
import '/helpers/globals.dart' as globals;

ThemeMode themeMode = ThemeMode.system;

bool getTheme(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
  return darkModeOn;
}
