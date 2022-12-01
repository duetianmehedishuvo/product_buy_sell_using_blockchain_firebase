import 'package:flutter/material.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: CustomButton(btnTxt: 'Add Product',onTap: (){},radius: 0,),
      ),
      appBar: AppBar(
        title: CustomText(title: 'Product', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
      ),
    );
  }
}
