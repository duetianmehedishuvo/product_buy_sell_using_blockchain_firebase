import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

import '../util/image.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isBackButtonExist;
  final Function? onBackPressed;
  final double? appBarSize;
  final bool? isHomeScreen;
  final double borderRadius;
  final bool? isShowCart;
  final bool? isShowAdd;
  final bool isOpenDashboardScreenFalse;
  final bool isOpenDashboardScreenTrue;
  final bool isShowQuoteIcon;
  final bool isShowHeaderColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.isBackButtonExist = true,
    this.isShowCart = true,
    this.isShowAdd = false,
    this.isOpenDashboardScreenFalse = false,
    this.isOpenDashboardScreenTrue = false,
    this.isShowQuoteIcon = false,
    this.isShowHeaderColor = false,
    this.onBackPressed,
    this.appBarSize = 85,
    this.borderRadius = 20,
    this.isHomeScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, appBarSize!),
      child: Container(
        height: appBarSize,
        padding: const EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: !isShowHeaderColor ? AppColors.primaryColorDark : AppColors.primaryColorDark,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(borderRadius), bottomRight: Radius.circular(borderRadius))),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isBackButtonExist!
                    ? IconButton(
                        icon: Image.asset(ImagesModel.backIcon, width: 20, height: 20),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: !isBackButtonExist! ? 30.0 : 15, top: !isBackButtonExist! ? 10.0 : 0),
                      child: Text(title!,
                          style: const TextStyle(fontSize: 18, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ),
                const SizedBox(width: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, appBarSize!);
}

AppBar buildAppBar(String title) {
  return AppBar(
      title: CustomText(title: title, textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
      backgroundColor: colorPrimary,
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 60);
}
