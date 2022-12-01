
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      // child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0),
    );
  }
}
