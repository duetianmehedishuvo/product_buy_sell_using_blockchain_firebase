
import 'package:flutter/material.dart';
import 'package:product_buy_sell/helper/age_helper.dart';
import 'package:product_buy_sell/localization/language_constrants.dart';

String getDate(String date, BuildContext context) {
  String createTime = '';
  DateTime time = DateTime.parse(date);

  AgeDuration age = Age.dateDifference(fromDate: time, toDate: DateTime.now(), includeToDate: false);
  int hourCompare = DateTime.now().hour - time.hour;
  int minuteCompare = DateTime.now().minute - time.minute;
  createTime = age.years > 0
      ? "${age.years} ${getTranslated('ye ago', context)}"
      : age.months > 0
          ? "${age.months} ${getTranslated('mo ago', context)}"
          : age.days > 0
              ? "${age.days} ${getTranslated('da ago', context)}"
              : hourCompare > 0
                  ? "$hourCompare ${getTranslated('ho ago', context)}"
                  : "$minuteCompare ${getTranslated('mi ago', context)}";

  return createTime;
}

// String convertPriceRetString(double price, String sym) {
//   return '${removeDecimalZeroFormat(price)} ${sym}';
// }

// String removeDecimalZeroFormat(double n) {
//   var formatter = n.truncateToDouble() == n ? NumberFormat('###,###,###') : NumberFormat('###,###,###.00');
//   return formatter.format(n);
// }
//
// String numberFormat(int n) {
//   var formatter = n.truncateToDouble() == n ? NumberFormat('#,##,###') : NumberFormat('#,##,###');
//   return formatter.format(n);
// }

bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  return double.tryParse(s) != null;
}
