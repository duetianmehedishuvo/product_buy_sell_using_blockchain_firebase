import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(String dateTime) {
    // return DateFormat('yyyy-MM-dd').format(dateTime);
    return DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime));
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm a').format(dateTime.toUtc());
  }

  static String localDateToString(String dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm a').format(DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime));
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  }

  static String dateFormatStyle2(DateTime dateTime) {
    String date = DateFormat('dd-MMM-yy').format(dateTime);
    return date;
  }
}
