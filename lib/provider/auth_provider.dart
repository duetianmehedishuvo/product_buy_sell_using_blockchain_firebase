import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/data/repository/auth_repo.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';

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
  Future<bool> addUser(UserModels userModels, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    if (await FireStoreDatabaseHelper.checkIfWishUserExists(userModels.phone!) == true) {
      showMessage(context, message: 'User already exists');
      _isLoading = false;
      notifyListeners();
      return false;
    } else {
      FireStoreDatabaseHelper.addUser(userModels);
      showMessage(context, message: 'User added successfully');
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  //TODO:: for Login Section

  UserModels userModels = UserModels();

  Future<int> login(String phone, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    int value = await FireStoreDatabaseHelper.loginUser(phone, password);

    _isLoading = false;

    notifyListeners();
    if (value == 1) {
      return 1;
    } else if (value == 0) {
      userModels = await FireStoreDatabaseHelper.getUserData(phone);
      userType = userModels.userType!;
      authRepo.saveUserInformation(userModels.address!, userModels.name!, userModels.phone!, userModels.userType!);
      Timer(Duration(seconds: 4), () {});
      notifyListeners();
      return 0;
    } else {
      return -1;
    }
  }

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
  String userAddress = '';
  String phone = '';
  int userType = 0;

  void getUserInfo() {
    name = authRepo.getUserName();
    userAddress = authRepo.getUserAddress();
    userType = authRepo.getUserType();
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
