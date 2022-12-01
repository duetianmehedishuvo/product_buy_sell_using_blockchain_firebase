import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:product_buy_sell/widgets/fancy_toasts.dart';

void showSuccessfullyMessage({String message = '', String title = '', BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: SuccessToast(body: message, title: title, widget: Icon(Iconsax.tag, size: 16, color: Colors.white)),
  ));
}
