import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class DistributorsProductSearchScreen extends StatelessWidget {
  final String searchResult;

  const DistributorsProductSearchScreen(this.searchResult, {Key? key}) : super(key: key);

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
                        return decryptedText(productModel.distributorsID!) != Provider.of<AuthProvider>(context, listen: false).phone
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
                                          productModel.isAssignRetailer == false
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(.1),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 3.0,
                                                    offset: const Offset(0.0, 0.0))
                                              ],
                                              borderRadius: BorderRadius.circular(7)),
                                          child: Column(
                                            children: [
                                              CustomText(
                                                  title: 'Select Retailer:',
                                                  textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                                              DropdownButton(
                                                value: dashboardProvider.selectRetailer,
                                                isExpanded: true,
                                                icon: const Icon(Icons.keyboard_arrow_down),
                                                items: dashboardProvider.retailerLists.map((UserModels items) {
                                                  return DropdownMenuItem(
                                                      value: items,
                                                      child: CustomText(
                                                          title: '${items.name!} -(${items.phone})',
                                                          color: Colors.black,
                                                          textStyle: sfProStyle500Medium.copyWith(color: Colors.black, fontSize: 15)));
                                                }).toList(),
                                                onChanged: (UserModels? newValue) {
                                                  dashboardProvider.changeRetailers(newValue!);
                                                },
                                              ),
                                              const SizedBox(height: 13),
                                              SizedBox(
                                                  width: 170,
                                                  child: CustomButton(
                                                      btnTxt: 'Assign & Verified',
                                                      onTap: () {
                                                        dashboardProvider.assignProductOnRetailers(context).then((value) {
                                                          if (value == true) {
                                                            Navigator.of(context).pop();
                                                          }
                                                        });
                                                      }))
                                            ],
                                          ),
                                        )
                                      : StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection(user)
                                              .doc(decryptedText(productModel.retailerID!))
                                              .snapshots(),
                                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                  child: Text(
                                                "Retailers Not Found",
                                                textAlign: TextAlign.center,
                                                style: sfProStyle700Bold.copyWith(color: colorPrimary, fontSize: 16),
                                              ));
                                            }
                                            UserModels deliveryManModels =
                                                UserModels.fromJson(snapshot.data!.data() as Map<String, dynamic>);
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
                                                      title: 'Retailers DETAILS:',
                                                      textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                                                  Divider(color: Colors.red.withOpacity(.3)),
                                                  customRow('ID:', deliveryManModels.phone!),
                                                  customRow('NAME:', deliveryManModels.name!),
                                                  customRow('ADDRESS:', deliveryManModels.address!),
                                                ],
                                              ),
                                            );
                                          }),
                                ],
                              );
                      })
                  : Center(
                      child: Text('Please Search Correct Product', style: sfProStyle700Bold.copyWith(fontSize: 16, color: colorPrimary))),
            ));
  }
}
