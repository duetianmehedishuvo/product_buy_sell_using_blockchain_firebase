import 'package:product_buy_sell/data/model/response/language_model.dart';
import 'package:product_buy_sell/util/app_constant.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstant.languagesList;
  }
}
