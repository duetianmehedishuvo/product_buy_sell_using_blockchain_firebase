import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/screens/auth/login_screen.dart';
import 'package:product_buy_sell/screens/customer/search/qr_search_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/image.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class CustomersDashboardScreen extends StatefulWidget {
  final String phone;

  const CustomersDashboardScreen(this.phone, {Key? key}) : super(key: key);

  @override
  State<CustomersDashboardScreen> createState() => _CustomersDashboardScreenState();
}

class _CustomersDashboardScreenState extends State<CustomersDashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<AuthProvider>(context, listen: false).getUserInfo();
    Provider.of<AdminDashboardProvider>(context, listen: false).getDeliveryManProductInfo(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: CustomText(title: 'Customer Dashboard', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 16)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
              onPressed: () {
                Helper.toRemoveUntilScreen(context, LoginScreen());
              },
              icon: const Icon(Icons.logout))
        ],
        toolbarHeight: 60,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 15),
          CustomText(
              title: 'Hello, ${Provider.of<AuthProvider>(context, listen: false).name}',
              textStyle: sfProStyle600SemiBold.copyWith(fontSize: 15)),
          const SizedBox(height: 15),
          CustomButton(
            btnTxt: 'SCAN PRODUCT',
            onTap: () {
              Helper.toScreen(context, const QRSearchScreen());
            },
          ),
          const SizedBox(height: 15),
          CustomText(
              title: 'Your Product List:',
              textStyle: sfProStyle700Bold.copyWith(fontSize: 17, color: colorPrimary),
              textAlign: TextAlign.start),
          const SizedBox(height: 15),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection(products).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                if (!snapshots.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshots.data!.docs.isEmpty) {
                    return Center(child: Text('No data available', style: sfProStyle600SemiBold.copyWith(fontSize: 16)));
                  } else {
                    return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        ProductModel products = ProductModel.fromJson(snapshots.data!.docs[index].data() as Map<String, dynamic>);

                        return (products.customerID == widget.phone)
                            ? InkWell(
                                onTap: () {
                                  Helper.toScreen(context, ProductDetailsScreen(products, isHideDistributorsInfo: true));
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
                                                textStyle: sfProStyle400Regular.copyWith(color: Colors.black87, fontSize: 14)),
                                            const SizedBox(height: 3),
                                            customRow2('Government Verified:', products.manufacturerVerifiedStatus!),
                                            const SizedBox(height: 3),
                                            customRow2('Distributors Verified:', products.distributorsVerifiedStatus!),
                                            const SizedBox(height: 3),
                                            customRow2('Retailer Verified:', products.retailerVerifiedStatus!),
                                            const SizedBox(height: 3),
                                            customRow3('Sell Status:', products.status! == 0 ? "No" : "YES"),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward, color: Colors.black)
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    );
                  }
                }
              }),
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
