import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RetailersProductSearchScreen extends StatelessWidget {
  final String searchResult;

  const RetailersProductSearchScreen(this.searchResult, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
        builder: (context, dashboardProvider, child) => Scaffold(
              appBar: buildAppBar('Product Info'),
              body: searchResult.length > 10 && searchResult.substring(0, 9) == 'Products_'
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(products)
                          .doc(decryptedText(searchResult.replaceAll('Products_ ', "")))
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData || snapshot.data!.data() == null) {
                          return Center(
                              child: Text("Sorry, there is no data in this Product Search",
                                  textAlign: TextAlign.center, style: sfProStyle700Bold.copyWith(color: colorPrimary, fontSize: 16)));
                        }

                        ProductModel productModel = ProductModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

                        return decryptedText(productModel.retailerID!) != Provider.of<AuthProvider>(context, listen: false).phone
                            ? Center(
                                child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  Text("Sorry, This Product is not available for you.",
                                      textAlign: TextAlign.center, style: sfProStyle700Bold.copyWith(color: colorPrimary, fontSize: 16)),
                                  const SizedBox(height: 30),
                                  CustomButton(
                                    btnTxt: 'Close',
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ))
                            : ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                children: [
                                  productDetailsView(productModel),
                                  productModel.manufacturerVerifiedStatus == true &&
                                          productModel.isAssignDistributor == true &&
                                          productModel.isAssignRetailer == true &&
                                          productModel.retailerVerifiedStatus == false
                                      ? SizedBox(
                                          width: 130,
                                          child: CustomButton(
                                              btnTxt: 'Verified',
                                              onTap: () {
                                                dashboardProvider.verifiedByRetailerProduct().then((value) {
                                                  if (value == true) {
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                              }))
                                      : const SizedBox.shrink()
                                ],
                              );
                      })
                  : Center(
                      child: Text('Please Search Correct Product', style: sfProStyle700Bold.copyWith(fontSize: 16, color: colorPrimary))),
            ));
  }
}
