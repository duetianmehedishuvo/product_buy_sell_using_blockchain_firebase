import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class DistributorsProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;

  const DistributorsProductDetailsScreen(this.productModel, {Key? key}) : super(key: key);

  @override
  State<DistributorsProductDetailsScreen> createState() => _DistributorsProductDetailsScreenState();
}

class _DistributorsProductDetailsScreenState extends State<DistributorsProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.productModel.govtVerifiedStatus == true &&
        widget.productModel.isAssignDistributor == true &&
        widget.productModel.isAssignRetailer == false) {
      Provider.of<AdminDashboardProvider>(context, listen: false).getAllData1();
    }
    Provider.of<AdminDashboardProvider>(context, listen: false).updateProductID(widget.productModel.productId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Product Details"),
      body: Consumer<AdminDashboardProvider>(
        builder: (context, dashboardProvider, child) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            customRow1('ID:', widget.productModel.productId.toString()),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow1('TITLE:', decryptedText(widget.productModel.title.toString())),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow1('Quantity:', widget.productModel.quantity.toString()),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow1('PRICE:', widget.productModel.quantity.toString()),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow1('MANUFACTURE DATE:', decryptedText(widget.productModel.manufacturerDate.toString())),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow1('EXPIRED DATE:', decryptedText(widget.productModel.expiredDate.toString())),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow2('Government Verified:', widget.productModel.govtVerifiedStatus!),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow2('Distributors Verified:', widget.productModel.distributorsVerifiedStatus!),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow2('Retailer Verified:', widget.productModel.retailerVerifiedStatus!),
            Divider(color: Colors.black.withOpacity(.1)),
            customRow3('Sell Status:', widget.productModel.status! == 0 ? "No" : "YES"),
            Divider(color: Colors.black.withOpacity(.1)),
            const SizedBox(height: 15),

            widget.productModel.govtVerifiedStatus == true &&
                    widget.productModel.isAssignDistributor == true &&
                    widget.productModel.isAssignRetailer == false
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(.1), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                        ],
                        borderRadius: BorderRadius.circular(7)),
                    child: Column(
                      children: [
                        CustomText(title: 'Select Retailer:', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
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
                    stream: FirebaseFirestore.instance.collection(user).doc(decryptedText(widget.productModel.retailerID!)).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                          "Retailers Not Found",
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
                                  color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                title: 'Retailers DETAILS:', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                            Divider(color: Colors.red.withOpacity(.3)),
                            customRow('ID:', deliveryManModels.phone!),
                            customRow('NAME:', deliveryManModels.name!),
                            customRow('ADDRESS:', deliveryManModels.address!),
                          ],
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}

