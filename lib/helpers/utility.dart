// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

class Utility {
  static String formatDateTime(String dateTime) {
    var formatter = DateFormat('MMM dd, yyyy');
    var formatter2 = DateFormat('hh:mm a');
    DateTime dt = DateTime.parse(dateTime);
    if (dt.day == DateTime.now().day) {
      return formatter2.format(dt);
    } else {
      return formatter.format(dt);
    }
  }

  static String markDownToHtml(String markDown) {
    var html = markDown;
    html = html.replaceAll('\n', '<br>');
    return html;
  }

  static bool isCheckedListItem(String listItem) {
    return listItem.contains("~");
  }

  static String stripTags(String listItem) {
    String item = listItem;
    item = item.replaceAll('~', '');
    item = item.replaceAll('[CHECKBOX]\n', '');
    return item;
  }
}

enum ThemeModeState { light, dark, system }
enum SupportState {
  unknown,
  supported,
  unsupported,
}
