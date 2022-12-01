import 'package:flutter/material.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/auth/widget/header_widget.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:product_buy_sell/widgets/custom_text_field.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController outletNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final FocusNode outletNameFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Stack(
          children: [
            SizedBox(width: getAppSizeWidth(context), height: getAppSizeHeight(context)),
            const HeaderWidget(title: 'Create Account', subTitle: 'Fill the below form to create a new account.', isShowBackButton: true),
            Container(
              margin: const EdgeInsets.only(top: 70),
              height: getAppSizeHeight(context),
              width: getAppSizeWidth(context),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) => ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: getAppSizeHeight(context) * 0.18),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [BoxShadow(color: colorShadow2, blurRadius: 10.0, spreadRadius: 3.0, offset: Offset(0.0, 0.0))],
                          borderRadius: BorderRadius.circular(9)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 3),
                              const Expanded(child: CustomText(title: 'Select Role', color: Colors.black, fontSize: 16)),
                              DropdownButton<String>(
                                value: authProvider.selectUserRoll,
                                items: authProvider.userRollLists
                                    .map((label) =>
                                        DropdownMenuItem(child: CustomText(title: label, color: Colors.black, fontSize: 17), value: label))
                                    .toList(),
                                underline: const SizedBox.shrink(),
                                onChanged: (value) {
                                  authProvider.changeUserRoll(value!);
                                },
                              ),
                            ],
                          ),
                          CustomTextField(
                            hintText: 'Outlet Name',
                            prefixIconUrl: Icons.share_location_outlined,
                            inputType: TextInputType.name,
                            isShowPrefixIcon: true,
                            verticalSize: 13,
                            focusNode: outletNameFocus,
                            nextFocus: firstNameFocus,
                            controller: outletNameController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hintText: 'First Name',
                            prefixIconUrl: Icons.account_circle,
                            inputType: TextInputType.name,
                            isShowPrefixIcon: true,
                            verticalSize: 13,
                            focusNode: firstNameFocus,
                            nextFocus: lastNameFocus,
                            controller: firstNameController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hintText: 'Last Name',
                            prefixIconUrl: Icons.account_circle,
                            inputType: TextInputType.name,
                            isShowPrefixIcon: true,
                            verticalSize: 13,
                            focusNode: lastNameFocus,
                            nextFocus: phoneFocus,
                            controller: lastNameController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hintText: 'Mobile Number',
                            prefixIconUrl: Icons.phone_android_outlined,
                            inputType: TextInputType.phone,
                            isShowPrefixIcon: true,
                            verticalSize: 13,
                            focusNode: phoneFocus,
                            nextFocus: emailFocus,
                            controller: phoneController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hintText: 'Email',
                            prefixIconUrl: Icons.mail_rounded,
                            inputType: TextInputType.emailAddress,
                            isShowPrefixIcon: true,
                            verticalSize: 13,
                            focusNode: emailFocus,
                            nextFocus: cityFocus,
                            controller: emailController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hintText: 'City',
                            prefixIconUrl: Icons.add_location_sharp,
                            inputType: TextInputType.name,
                            isShowPrefixIcon: true,
                            verticalSize: 13,
                            focusNode: cityFocus,
                            nextFocus: passwordFocus,
                            controller: cityController,
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
                          authProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : CustomButton(
                                  btnTxt: 'Register',
                                  onTap: () {
                                    // authProvider
                                    //     .signup(firstNameController.text, lastNameController.text, phoneController.text,
                                    //         emailController.text, passwordController.text, outletNameController.text)
                                    //     .then((value) {
                                    //   if (value.status == true) {
                                    //     showMessage(context, message: value.message, isError: false);
                                    //     Navigator.of(context).pop();
                                    //   } else {
                                    //     showMessage(context, message: value.message);
                                    //   }
                                    // });
                                  }),
                          const SizedBox(height: 20),
                          CustomText(title: 'Have an account?', textStyle: sfProStyle300Light.copyWith(color: colorPrimary, fontSize: 16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  title: 'Please Login ', textStyle: sfProStyle400Regular.copyWith(color: colorPrimary, fontSize: 16)),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const CustomText(
                                      title: 'Click Here', decoration: TextDecoration.underline, color: colorBlueDark, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
