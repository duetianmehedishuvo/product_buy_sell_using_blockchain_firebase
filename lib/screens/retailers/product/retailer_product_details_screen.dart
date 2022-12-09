import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RetailerProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;

  const RetailerProductDetailsScreen(this.productModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<AdminDashboardProvider>(context, listen: false).updateProductID(productModel.productId!);

    return Scaffold(
      appBar: buildAppBar("Product Details"),
      body: Consumer<AdminDashboardProvider>(
        builder: (context, dashboardProvider, child) => ListView(
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
                : const SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}
