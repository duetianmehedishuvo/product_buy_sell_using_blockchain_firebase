
import 'package:product_buy_sell/data/repository/splash_repo.dart';
import 'package:product_buy_sell/util/app_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final SplashRepo splashRepo;

  ThemeProvider({required this.sharedPreferences, required this.splashRepo}) {
    loadCurrentTheme();
  }

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  void toggleTheme() {
      _darkTheme = !_darkTheme;
      sharedPreferences.setBool(AppConstant.theme, _darkTheme);

    notifyListeners();
  }

  void loadCurrentTheme() async {
    _darkTheme = sharedPreferences.getBool(AppConstant.theme) ?? false;
    //notifyListeners();
  }



}
