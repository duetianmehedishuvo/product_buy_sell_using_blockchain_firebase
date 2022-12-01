import 'package:flutter/material.dart';
import 'package:product_buy_sell/util/image.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget(
      {this.title = 'Login', this.isShowBackButton = false, this.subTitle = 'Welcome back, please login to your account.', Key? key})
      : super(key: key);
  final String title;
  final String subTitle;
  final bool isShowBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getAppSizeHeight(context) * 0.4,
      width: getAppSizeWidth(context),
      decoration: const BoxDecoration(
          color: colorPrimary, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: isShowBackButton ? 40 : 50),
          isShowBackButton
              ? Container(
                  width: getAppSizeWidth(context),
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Icon(backIcon(context), color: Colors.white), const CustomText(title: 'Back')],
                    ),
                  ))
              : const SizedBox.shrink(),
          SizedBox(height: isShowBackButton ? 10 : 0),
          Container(
              width: getAppSizeWidth(context) * 0.6,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              height: 84,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: Image.asset(ImagesModel.logo)),
          const SizedBox(height: 8),
          Center(child: CustomText(title: title, textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 18))),
          const SizedBox(height: 5),
          Center(
            child: CustomText(
              title: subTitle,
              textStyle: sfProStyle300Light.copyWith(color: Colors.white, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
