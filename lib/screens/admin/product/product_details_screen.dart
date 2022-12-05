import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  final bool isHideDistributorsInfo;

  const ProductDetailsScreen(this.productModel, {this.isHideDistributorsInfo = false, Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminDashboardProvider>(context, listen: false).getUserInfo(decryptedText(widget.productModel.deliveryManID!),
        decryptedText(widget.productModel.distributorsID!), widget.productModel.productId.toString());
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
            customRow1(
                'STATUS:',
                widget.productModel.status == 0
                    ? "NOT ASSIGNED"
                    : widget.productModel.status == 1
                        ? "ASSIGNED"
                        : widget.productModel.status == 2
                            ? "OUT FOR DELIVERY"
                            : "COMPLETED"),
            Divider(color: Colors.black.withOpacity(.1)),
            const SizedBox(height: 15),
            dashboardProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.isHideDistributorsInfo
                          ? const SizedBox.shrink()
                          : Container(
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
                                      title: 'DISTRIBUTORS DETAILS:',
                                      textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                                  Divider(color: Colors.red.withOpacity(.3)),
                                  customRow('ID:', dashboardProvider.distributorsModels.phone!),
                                  customRow('NAME:', dashboardProvider.distributorsModels.name!),
                                  customRow('ADDRESS:', dashboardProvider.distributorsModels.address!),
                                ],
                              ),
                            ),
                      SizedBox(height: widget.isHideDistributorsInfo ? 0 : 15),
                      Container(
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
                                title: 'DELIVERY MAN DETAILS:',
                                textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                            Divider(color: Colors.red.withOpacity(.3)),
                            customRow('ID:', dashboardProvider.deliveryManModels.phone!),
                            customRow('NAME:', dashboardProvider.deliveryManModels.name!),
                            customRow('ADDRESS:', dashboardProvider.deliveryManModels.address!),
                          ],
                        ),
                      )
                    ],
                  ),
            const SizedBox(height: 15),
            widget.isHideDistributorsInfo
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Screenshot(
                          controller: dashboardProvider.screenshotController,
                          child: dashboardProvider.qrCodeWidget(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        btnTxt: 'SAVE QR',
                        onTap: () {
                          dashboardProvider.captureScreenshot();
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

Widget customRow1(String title, String subTitle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(title.toUpperCase(), style: sfProStyle700Bold.copyWith(fontSize: 15)),
      const SizedBox(width: 10),
      Expanded(child: Text(subTitle, style: sfProStyle500Medium.copyWith(fontSize: 17))),
    ],
  );
}

Widget customRow(String title, String subTitle) {
  return Container(
    margin: const EdgeInsets.only(bottom: 3),
    child: Row(
      children: [
        Text(title, style: sfProStyle500Medium.copyWith(fontSize: 15)),
        const SizedBox(width: 10),
        Expanded(child: Text(subTitle, style: sfProStyle400Regular.copyWith(fontSize: 17))),
      ],
    ),
  );
}
