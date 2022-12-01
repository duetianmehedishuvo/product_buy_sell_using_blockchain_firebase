import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_buy_sell/screens/admin/delivery_man/deleveryman_screen.dart';
import 'package:product_buy_sell/screens/admin/distributors/distributors_screen.dart';
import 'package:product_buy_sell/screens/admin/product/product_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/image.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: CustomText(title: 'Admin Dashboard', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {},
          child: Container(alignment: Alignment.center, child: SvgPicture.asset(ImagesModel.menuIcons, width: 25, height: 20)),
        ),
        toolbarHeight: 60,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          Helper.toScreen(context, const ProductScreen());
                        },
                        child: menuWidget2(customRoundImage(ImagesModel.currencyIcons, 20), 'Products'))),
                const SizedBox(width: 15),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Helper.toScreen(context, const DeliveryManScreen());
                  },
                  child: menuWidget2(customRoundImage(ImagesModel.currencyIcons, 20), 'Delivery Man'),
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Helper.toScreen(context, const DistributorsScreen());
                  },
                  child: menuWidget2(customRoundImage(ImagesModel.currencyIcons, 20), 'Distributors'),
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    // Helper.toScreen(context, const AllCustomerDateWiseScreen());
                  },
                  child: menuWidget2(customRoundImage(ImagesModel.currencyIcons, 20), 'Report'),
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 15),
          //   child: Row(
          //     children: [
          //       Expanded(
          //           child: InkWell(
          //               onTap: () {
          //                 // Helper.toScreen(context, const SliderScreen());
          //               },
          //               child: menuWidget3('Slider'))),
          //       const SizedBox(width: 15),
          //       Expanded(
          //           child: InkWell(
          //               onTap: () {
          //                 // Helper.toScreen(context, const SliderRunningTextScreen());
          //               },
          //               child: menuWidget3('Running Text'))),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget menuWidget(Widget imageWidget, String title) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(color: colorShadow, blurRadius: 10.0, spreadRadius: 3.0, offset: Offset(0.0, 0.0))],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageWidget,
          const SizedBox(height: 15),
          CustomText(title: title, textStyle: sfProStyle700Bold.copyWith(color: colorText, fontSize: 16))
        ],
      ),
    );
  }

  Widget menuWidget3(String title) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(color: colorShadow, blurRadius: 10.0, spreadRadius: 3.0, offset: Offset(0.0, 0.0))],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CustomText(title: title, textStyle: sfProStyle700Bold.copyWith(color: colorText, fontSize: 16))],
      ),
    );
  }

  Widget menuWidget2(Widget imageWidget, String title) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(color: colorShadow, blurRadius: 10.0, spreadRadius: 3.0, offset: Offset(0.0, 0.0))],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageWidget,
          const SizedBox(height: 15),
          CustomText(title: title, textStyle: sfProStyle400Regular.copyWith(color: colorText, fontSize: 14))
        ],
      ),
    );
  }

  Widget customRoundImage(String imageUrl, double size) {
    return Stack(children: [
      SvgPicture.asset(ImagesModel.rectangleIcons, width: size * 2, height: size * 2),
      Positioned(left: 0, right: 0, top: 0, bottom: 0, child: Center(child: SvgPicture.asset(imageUrl, width: size, height: size))),
    ]);
  }
}
