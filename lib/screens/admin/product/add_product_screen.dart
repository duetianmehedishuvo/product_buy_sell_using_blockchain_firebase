import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/Product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/screens/admin/product/add_product_screen2.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:product_buy_sell/widgets/custom_text_field.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key? key}) : super(key: key);
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController quantityEditingController = TextEditingController();
  final TextEditingController priceEditingController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode quantityFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: CustomText(title: 'Add Product', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Consumer<AdminDashboardProvider>(
        builder: (context, dashboardProvider, child) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          physics: const BouncingScrollPhysics(),
          children: [
            CustomTextField(
                hintText: 'Title',
                prefixIconUrl: Icons.title,
                inputType: TextInputType.text,
                isShowPrefixIcon: true,
                verticalSize: 15,
                focusNode: titleFocusNode,
                nextFocus: quantityFocusNode,
                controller: titleEditingController,
                isCancelShadow: true),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: 'Quantity',
                prefixIconUrl: Icons.query_stats,
                inputType: TextInputType.number,
                isShowPrefixIcon: true,
                focusNode: quantityFocusNode,
                nextFocus: priceFocusNode,
                controller: quantityEditingController,
                verticalSize: 15,
                isCancelShadow: true),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: 'Price',
                prefixIconUrl: Icons.price_check,
                inputType: TextInputType.number,
                isShowPrefixIcon: true,
                verticalSize: 15,
                focusNode: priceFocusNode,
                controller: priceEditingController,
                inputAction: TextInputAction.done,
                isCancelShadow: true),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 170,
                    child: CustomButton(
                      btnTxt: 'Manufacturer Date',
                      onTap: () {
                        dashboardProvider.changeManufacturerDate(context);
                      },
                      fontSize: 16,
                    )),
                CustomText(
                  title: dashboardProvider.manufacturerDate,
                  color: Colors.black,
                )
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 170,
                    child: CustomButton(
                      btnTxt: 'Expire Date',
                      onTap: () {
                        dashboardProvider.changeExpireDate(context);
                      },
                      fontSize: 16,
                    )),
                CustomText(title: dashboardProvider.expireDateText, color: Colors.black)
              ],
            ),
            const SizedBox(height: 40),
            CustomButton(
              btnTxt: 'SAVE',
              onTap: () {
                if (titleEditingController.text.isEmpty || quantityEditingController.text.isEmpty || priceEditingController.text.isEmpty) {
                  showMessage(context, message: 'please write all of the form fields');
                } else {
                  ProductModel productModel = ProductModel(
                    productId: DateTime.now().microsecondsSinceEpoch,
                    title: encryptedText(titleEditingController.text),
                    quantity: int.parse(quantityEditingController.text),
                    price: double.parse(priceEditingController.text),
                    manufacturerDate: encryptedText(dashboardProvider.manufacturerDate),
                    expiredDate: encryptedText(dashboardProvider.expireDateText),
                    deliveryManID: encryptedText("-1"),
                    distributorsID: encryptedText("-1"),
                  );

                  dashboardProvider.addProduct(productModel, context).then((value) {
                    if (value == true) {
                      Helper.toScreen(context, const AddProductScreen2());
                    }
                  });
                }
              },
              fontSize: 16,
            )
          ],
        ),
      ),
    );
  }
}
