import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserModels userModels;

  const UserDetailsScreen(this.userModels, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomText(title: 'User Details', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
          backgroundColor: colorPrimary,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 60),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          customRow("NAME:", userModels.name!),
          Divider(color: Colors.black.withOpacity(.1)),
          customRow("Phone:", userModels.phone!),
          Divider(color: Colors.black.withOpacity(.1)),
          customRow("Address:", userModels.address!),
          Divider(color: Colors.black.withOpacity(.1)),
          customRow("User Type:", userModels.userType == 0 ? "Distributors" : "Delivery Man"),
          Divider(color: Colors.black.withOpacity(.1)),
        ],
      ),
    );
  }

  Widget customRow(String title, String subTitle) {
    return Row(
      children: [
        Text(title, style: sfProStyle700Bold.copyWith(fontSize: 15)),
        const SizedBox(width: 10),
        Text(subTitle, style: sfProStyle500Medium.copyWith(fontSize: 17)),
      ],
    );
  }
}
