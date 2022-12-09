import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/screens/admin/product/add_product_screen.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: CustomButton(
          btnTxt: 'Add Product',
          onTap: () {
            Helper.toScreen(context, AddProductScreen());
          },
          radius: 0,
        ),
      ),
      appBar: AppBar(
          title: CustomText(title: 'Product', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
          backgroundColor: colorPrimary,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 60),
      body: StreamBuilder(
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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    ProductModel products = ProductModel.fromJson(snapshots.data!.docs[index].data() as Map<String, dynamic>);

                    return InkWell(
                      onTap: () {
                        Helper.toScreen(context, ProductDetailsScreen(products));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(.1), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
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
                                  customRow2('Manufacturer Verified:', products.manufacturerVerifiedStatus!),
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
                    );
                  },
                );
              }
            }
          }),
    );
  }
}
