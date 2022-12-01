import 'package:flutter/material.dart';

void showMessage(BuildContext context,{String? message, bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message!, style: const TextStyle(color: Colors.white)), backgroundColor: isError ? Colors.red : Colors.green),
  );
}
