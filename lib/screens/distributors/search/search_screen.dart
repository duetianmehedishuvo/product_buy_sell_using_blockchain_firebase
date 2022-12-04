import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/screens/distributors/reports/add_reports_screen.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final String searchResult;

  const SearchScreen(this.searchResult, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
        builder: (context, dashboardProvider, child) => Scaffold(
              appBar: buildAppBar('SearchScreen'),
              body: searchResult.length > 10 && searchResult.substring(0, 9) == 'Products_'
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(products)
                          .doc(decryptedText(searchResult.replaceAll('Products_ ', "")))
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: Text(
                            "Sorry, there is no data in this QR CODE if think any doubt please complain here",
                            textAlign: TextAlign.center,
                            style: sfProStyle700Bold.copyWith(color: colorPrimary, fontSize: 16),
                          ));
                        }

                        ProductModel productModel = ProductModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                        return decryptedText(productModel.distributorsID!) != Provider.of<AuthProvider>(context, listen: false).phone
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "This Product is Not yours please contact with admin",
                                    textAlign: TextAlign.center,
                                    style: sfProStyle700Bold.copyWith(color: colorPrimary, fontSize: 16),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                      width: 200,
                                      child: CustomButton(
                                          btnTxt: 'Report this products',
                                          onTap: () {
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (_) => AddReportsScreen(searchResult.replaceAll('Products_ ', ""))));
                                          }))
                                ],
                              ))
                            : ListView(
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
                                  customRow1(
                                      'STATUS:',
                                      productModel.status == 0
                                          ? "NOT ASSIGNED"
                                          : productModel.status == 1
                                              ? "ASSIGNED"
                                              : productModel.status == 2
                                                  ? "OUT FOR DELIVERY"
                                                  : "COMPLETED"),
                                  Divider(color: Colors.black.withOpacity(.1)),
                                  const SizedBox(height: 15),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection(user)
                                          .doc(decryptedText(productModel.deliveryManID!))
                                          .snapshots(),
                                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child: Text(
                                            "Delivery Man Not Found",
                                            textAlign: TextAlign.center,
                                            style: sfProStyle700Bold.copyWith(color: colorPrimary, fontSize: 16),
                                          ));
                                        }
                                        UserModels deliveryManModels = UserModels.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                        return Container(
                                          width: getAppSizeWidth(context),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(.2),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 3.0,
                                                    offset: const Offset(0.0, 0.0))
                                              ],
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                  title: 'DELIVERY MAN DETAILS:',
                                                  textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                                              Divider(color: Colors.red.withOpacity(.3)),
                                              customRow('ID:', deliveryManModels.phone!),
                                              customRow('NAME:', deliveryManModels.name!),
                                              customRow('ADDRESS:', deliveryManModels.address!),
                                            ],
                                          ),
                                        );
                                      }),
                                  const SizedBox(height: 15),
                                  productModel.status == 2
                                      ? dashboardProvider.isLoading
                                          ? const Center(child: CircularProgressIndicator())
                                          : CustomButton(
                                              btnTxt: 'Confirm Order',
                                              onTap: () {
                                                dashboardProvider.updateProducts2(3, productModel.productId!.toString()).then((value) {
                                                  if (value == true) {
                                                    showMessage(context, message: 'Order confirm successfully', isError: false);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    showMessage(context, message: 'Order confirm Failed');
                                                  }
                                                });
                                              },
                                            )
                                      : const SizedBox.shrink()
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
