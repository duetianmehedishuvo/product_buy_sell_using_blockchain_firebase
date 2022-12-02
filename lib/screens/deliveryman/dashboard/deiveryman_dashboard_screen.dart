import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/screens/auth/login_screen.dart';
import 'package:product_buy_sell/screens/deliveryman/dashboard/deliveryman_product_details_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/image.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class DeliveryDashboardScreen extends StatefulWidget {
  const DeliveryDashboardScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryDashboardScreen> createState() => _DeliveryDashboardScreenState();
}

class _DeliveryDashboardScreenState extends State<DeliveryDashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminDashboardProvider>(context, listen: false)
        .getDeliveryManProductInfo(Provider.of<AuthProvider>(context, listen: false).phone);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: CustomText(title: 'Delivery Man Dashboard', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
              onPressed: () {
                Helper.toRemoveUntilScreen(context, LoginScreen());
              },
              icon: Icon(Icons.logout))
        ],
        toolbarHeight: 60,
      ),
      body: Consumer2<AuthProvider, AdminDashboardProvider>(
        builder: (context, authProvider, dashboardProvider, child) => dashboardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  const SizedBox(height: 15),
                  CustomText(title: 'Hello, ${authProvider.name}', textStyle: sfProStyle600SemiBold.copyWith(fontSize: 15)),
                  const SizedBox(height: 15),
                  dashboardProvider.products.isEmpty
                      ? Center(child: Text("NO DATA FOUND", style: sfProStyle600SemiBold.copyWith(fontSize: 16)))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dashboardProvider.products.length,
                          itemBuilder: (context, index) {
                            ProductModel products = dashboardProvider.products[index];

                            return InkWell(
                              onTap: () {
                                Helper.toScreen(context, DeliveryManDetailsScreen(products, index));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(.1),
                                          blurRadius: 10.0,
                                          spreadRadius: 3.0,
                                          offset: const Offset(0.0, 0.0))
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                              title: 'ID: ${products.productId}',
                                              color: Colors.black,
                                              textStyle: sfProStyle700Bold.copyWith(fontSize: 16)),
                                          const SizedBox(height: 3),
                                          CustomText(
                                            title: 'TITLE: ${decryptedText(products.title!)}',
                                            color: Colors.black,
                                            textStyle: sfProStyle400Regular.copyWith(color: Colors.black.withOpacity(.9), fontSize: 15),
                                          ),
                                          const SizedBox(height: 3),
                                          CustomText(
                                            title: 'MANUFACTURE DATE: ${decryptedText(products.manufacturerDate!)}',
                                            color: Colors.black87,
                                            textStyle: sfProStyle400Regular.copyWith(color: Colors.black87, fontSize: 14),
                                          ),
                                          const SizedBox(height: 3),
                                          customRow1(
                                              'STATUS:',
                                              products.status == 0
                                                  ? "NOT ASSIGNED"
                                                  : products.status == 1
                                                      ? "ASSIGNED"
                                                      : products.status == 2
                                                          ? "OUT FOR DELIVERY"
                                                          : "COMPLETED"),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                ],
              ),
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
      padding: const EdgeInsets.all(15),
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
