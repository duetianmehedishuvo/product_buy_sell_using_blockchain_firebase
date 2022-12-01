
import 'package:product_buy_sell/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.sharedPreferences});



  //TODO: for save User Information
  Future<void> saveUserInformation(String userID, String name, String phone, String email) async {
    try {
      await sharedPreferences.setString(AppConstant.userID, userID);
      await sharedPreferences.setString(AppConstant.userEmail, email);
      await sharedPreferences.setString(AppConstant.userName, name);
      await sharedPreferences.setString(AppConstant.phone, phone);
      getUserName();
      getUserID();
      getUserEmail();
      getUserPhone();
    } catch (e) {
      rethrow;
    }
  }


  Future<void> changeUserName(String value) async {
    try {
      await sharedPreferences.setString(AppConstant.userName, value);
    } catch (e) {
      rethrow;
    }
  }

  //TODO:: for get User Information
  String getUserID() {
    return sharedPreferences.getString(AppConstant.userID) ?? "";
  }

  String getUserName() {
    return sharedPreferences.getString(AppConstant.userName) ?? "";
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstant.userEmail) ?? "";
  }

  String getUserPhone() {
    return sharedPreferences.getString(AppConstant.phone) ?? "";
  }



  // TODO; clear all user Information
  Future<bool> clearUserInformation() async {
    await sharedPreferences.remove(AppConstant.userID);
    await sharedPreferences.remove(AppConstant.userName);
    await sharedPreferences.remove(AppConstant.phone);
    return await sharedPreferences.remove(AppConstant.userEmail);
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
