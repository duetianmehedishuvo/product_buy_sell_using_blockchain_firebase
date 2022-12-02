import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:product_buy_sell/widgets/custom_text_field.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';
import 'package:provider/provider.dart';

class AddDeliveryManScreen extends StatelessWidget {
  AddDeliveryManScreen({Key? key}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(title: 'Add Delivery Mane Info', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: colorShadow2, blurRadius: 10.0, spreadRadius: 3.0, offset: Offset(0.0, 0.0))],
                  borderRadius: BorderRadius.circular(9)),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Name *',
                    prefixIconUrl: Icons.share_location_outlined,
                    inputType: TextInputType.name,
                    isShowPrefixIcon: true,
                    verticalSize: 13,
                    focusNode: nameFocus,
                    nextFocus: phoneFocus,
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    hintText: 'Phone Number *',
                    prefixIconUrl: Icons.account_circle,
                    inputType: TextInputType.phone,
                    isShowPrefixIcon: true,
                    verticalSize: 13,
                    focusNode: phoneFocus,
                    nextFocus: addressFocus,
                    controller: phoneController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    hintText: 'addresses *',
                    prefixIconUrl: Icons.account_circle,
                    inputType: TextInputType.streetAddress,
                    isShowPrefixIcon: true,
                    verticalSize: 13,
                    focusNode: addressFocus,
                    nextFocus: passwordFocus,
                    controller: addressController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    hintText: 'Enter your password *',
                    prefixIconUrl: Icons.lock,
                    inputType: TextInputType.text,
                    isShowPrefixIcon: true,
                    verticalSize: 13,
                    controller: passwordController,
                    focusNode: passwordFocus,
                    inputAction: TextInputAction.done,
                    isShowSuffixIcon: true,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  authProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          btnTxt: 'Add',
                          onTap: () {
                            if (nameController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                addressController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              showMessage(context, message: 'Please fill upp all the fields');
                            } else {
                              authProvider
                                  .addUser(
                                      UserModels(
                                          name: nameController.text,
                                          address: addressController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text,
                                          userType: 1),
                                      context)
                                  .then((value) {
                                if (value == true) {
                                  Navigator.of(context).pop();
                                }
                              });
                            }
                          }),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
