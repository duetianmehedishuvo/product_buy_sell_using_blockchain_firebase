import 'package:product_buy_sell/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.sharedPreferences});

  //TODO: for save User Information
  Future<void> saveUserInformation(String address, String name, String phone, int type) async {
    try {
      await sharedPreferences.setString(AppConstant.userAddress, address);
      await sharedPreferences.setInt(AppConstant.userType, type);
      await sharedPreferences.setString(AppConstant.name, name);
      await sharedPreferences.setString(AppConstant.phone, phone);
      await sharedPreferences.setString(AppConstant.token, phone);
      getUserName();
      getUserAddress();
      getUserType();
      getUserPhone();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeName(String value) async {
    try {
      await sharedPreferences.setString(AppConstant.name, value);
    } catch (e) {
      rethrow;
    }
  }

  //TODO:: for get User Information
  String getUserAddress() {
    return sharedPreferences.getString(AppConstant.userAddress) ?? "";
  }

  String getUserName() {
    return sharedPreferences.getString(AppConstant.name) ?? "";
  }

  int getUserType() {
    return sharedPreferences.getInt(AppConstant.userType) ?? 0;
  }

  String getUserPhone() {
    return sharedPreferences.getString(AppConstant.phone) ?? "";
  }

  // TODO; clear all user Information
  Future<bool> clearUserInformation() async {
    await sharedPreferences.remove(AppConstant.userAddress);
    await sharedPreferences.remove(AppConstant.name);
    await sharedPreferences.remove(AppConstant.phone);
    return await sharedPreferences.remove(AppConstant.userType);
  }

  bool checkTokenExist() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstant.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  Future<bool> clearToken() async {
    return sharedPreferences.remove(AppConstant.token);
  }
}
