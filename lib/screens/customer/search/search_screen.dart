import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/screens/customer/reports/add_reports_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final String searchResult;

  const SearchScreen(this.searchResult, {Key? key}) : super(key: key);

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

                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          children: [
                            customRow1('ID:', productModel.productId.toString()),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow1('TITLE:', decryptedText(productModel.title.toString())),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow1('Quantity:', productModel.quantity.toString()),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow1('PRICE:', productModel.quantity.toString()),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow1('MANUFACTURE DATE:', decryptedText(productModel.manufacturerDate.toString())),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow1('EXPIRED DATE:', decryptedText(productModel.expiredDate.toString())),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow2('Government Verified:', productModel.govtVerifiedStatus!),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow2('Distributors Verified:', productModel.distributorsVerifiedStatus!),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow2('Retailer Verified:', productModel.retailerVerifiedStatus!),
                            Divider(color: Colors.black.withOpacity(.1)),
                            customRow3('Sell Status:', productModel.status! == 0 ? "No" : "YES"),
                            Divider(color: Colors.black.withOpacity(.1)),
                            const SizedBox(height: 15),
                            const SizedBox(height: 15),
                            productModel.status! != 0
                                ? const SizedBox.shrink()
                                : productModel.govtVerifiedStatus == false
                                    ? CustomButton(
                                        btnTxt: 'Report this Product',
                                        onTap: () {
                                          Helper.toScreen(context, AddReportsScreen(productModel.productId!.toString()));
                                        },
                                      )
                                    : CustomButton(
                                        btnTxt: 'Confirm Order',
                                        onTap: () {
                                          dashboardProvider
                                              .confirmProduct(productModel.productId!.toString(),
                                                  Provider.of<AuthProvider>(context, listen: false).phone)
                                              .then((value) {
                                            if (value == true) {
                                              showMessage(context, message: 'Order confirm successfully', isError: false);
                                              Navigator.of(context).pop();
                                            } else {
                                              showMessage(context, message: 'Order confirm Failed');
                                            }
                                          });
                                        },
                                      )
                          ],
                        );
                      })
                  : Center(
                      child: Text(
                        'Please Search Correct Product',
                        style: sfProStyle700Bold.copyWith(fontSize: 16, color: colorPrimary),
                      ),
                    ),
            ));
  }
}
