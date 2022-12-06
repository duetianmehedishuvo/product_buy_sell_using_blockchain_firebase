import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/admin_dashboard_screen/admin_dashboard_screen.dart';
import 'package:product_buy_sell/screens/auth/signup_screen.dart';
import 'package:product_buy_sell/screens/auth/widget/header_widget.dart';
import 'package:product_buy_sell/screens/govt/dashboard/govt_dashboard_screen.dart';
import 'package:product_buy_sell/screens/distributors/dashboard/distributors_dashboard_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:product_buy_sell/widgets/custom_text_field.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Stack(
          children: [
            SizedBox(width: getAppSizeWidth(context), height: getAppSizeHeight(context)),
            const HeaderWidget(),
            SizedBox(
              height: getAppSizeHeight(context),
              width: getAppSizeWidth(context),
              child: ListView(
                children: [
                  SizedBox(height: getAppSizeHeight(context) * 0.25),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BoxShadow(color: colorShadow2, blurRadius: 10.0, spreadRadius: 3.0, offset: Offset(0.0, 0.0))],
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'Mobile Number',
                          prefixIconUrl: Icons.phone_android_outlined,
                          inputType: TextInputType.phone,
                          isShowPrefixIcon: true,
                          verticalSize: 13,
                          controller: phoneController,
                          focusNode: phoneFocus,
                          nextFocus: passwordFocus,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: 'Enter your password',
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
                        InkWell(
                          onTap: () {},
                          focusColor: Colors.grey,
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: CustomText(
                                  title: 'Forgot Password?', textStyle: sfProStyle300Light.copyWith(color: colorPrimary, fontSize: 16))),
                        ),
                        const SizedBox(height: 20),
                        authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                btnTxt: 'Login',
                                onTap: () {
                                  if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
                                    showMessage(context, message: 'Please fill up all the fields');
                                  } else {
                                    authProvider.login(phoneController.text, passwordController.text, context).then((value) {
                                      if (value == 1) {
                                        showMessage(context, message: 'Phone No and password don\'t match');
                                      } else if (value == 0) {
                                        showMessage(context, message: 'Login Successfully', isError: false);

                                        FireStoreDatabaseHelper.getUserData(phoneController.text).then((value) {
                                          authProvider.saveUserInformation(value);
                                          // Provider.of<AuthProvider>(context, listen: false).getUserInfo();
                                          if (value.userType == 1) {
                                            Helper.toRemoveUntilScreen(context, const AdminDashboardScreen());
                                          } else if (value.userType == 0) {
                                            Helper.toRemoveUntilScreen(context, const GovtDashboardScreen());
                                          }  else if (value.userType == 2) {
                                            Helper.toRemoveUntilScreen(context, const DistributorsDashboardScreen());
                                          } else {
                                            Helper.toRemoveUntilScreen(context, const DistributorsDashboardScreen());
                                          }
                                        });
                                      } else {
                                        showMessage(context, message: 'Phone No not exists');
                                      }
                                    });
                                  }
                                }),
                        const SizedBox(height: 20),
                        CustomText(
                            title: 'Don\'t have an account?', textStyle: sfProStyle300Light.copyWith(color: colorPrimary, fontSize: 16)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                                title: 'Please Register ', textStyle: sfProStyle400Regular.copyWith(color: colorPrimary, fontSize: 16)),
                            InkWell(
                                onTap: () {
                                  Helper.toScreen(context, SignupScreen());
                                },
                                child: const CustomText(
                                    title: 'Click Here', decoration: TextDecoration.underline, color: colorBlueDark, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
