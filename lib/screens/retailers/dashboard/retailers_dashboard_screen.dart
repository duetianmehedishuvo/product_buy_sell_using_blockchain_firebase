import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/screens/auth/login_screen.dart';
import 'package:product_buy_sell/screens/retailers/product/retailer_product_details_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class RetailersDashboardScreen extends StatelessWidget {
  const RetailersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: CustomText(title: 'Retailers Dashboard', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 16)),
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

                        return (decryptedText(products.retailerID!) == Provider.of<AuthProvider>(context, listen: false).phone)
                            ? InkWell(
                                onTap: () {
                                  Helper.toScreen(context, RetailerProductDetailsScreen(products));
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
                                            customRow2('Government Verified:', products.govtVerifiedStatus!),
                                            const SizedBox(height: 3),
                                            customRow2('Distributors Verified:', products.distributorsVerifiedStatus!),
                                            const SizedBox(height: 3),
                                            customRow2('Retailers Verified:', products.retailerVerifiedStatus!),
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
}
