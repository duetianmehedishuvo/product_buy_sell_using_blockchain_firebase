import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/data/repository/auth_repo.dart';

class CallBackResponse {
  bool status;
  String message;

  CallBackResponse({this.status = false, this.message = ''});
}

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  //TODO:: for Sign Up Section


  String data = '';

  //// TODO: for send User Information
  DateTime _dateTime = DateTime.now();
  String dateTime = "";
  var buttonText = "Choose time";

  void showDateDialog(BuildContext context) {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(60), lastDate: DateTime.now()).then((value) {
      _dateTime = value!;
      buttonText = "${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()}";
      dateTime = buttonText;
      notifyListeners();
    });
  }

  List<String> genderLists = ["Male", "Female", "Other"];

  String selectGender = "Male";

  changeGenderStatus(String status) {
    selectGender = status;
    notifyListeners();
  }

  //TODO: for Logout
  Future<bool> logout() async {
    authRepo.clearToken();
    authRepo.clearUserInformation();
    return true;
  }

  //TODO: for Logout
  bool checkTokenExist() {
    return authRepo.checkTokenExist();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  // get User INFO:
  String name = '';
  String userID = '';
  String phone = '';
  String email = '';

  void getUserInfo() {
    name = authRepo.getUserName();
    userID = authRepo.getUserID();
    email = authRepo.getUserEmail();
    phone = authRepo.getUserPhone();

    notifyListeners();
  }

  //TODO: for user ROLL:
  List<String> userRollLists = ['Free'];
  String selectUserRoll = 'Free';

  changeUserRoll(String value) {
    selectUserRoll = value;
    notifyListeners();
  }
}
