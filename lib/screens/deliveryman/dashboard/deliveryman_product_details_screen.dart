import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/util/size.util.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DeliveryManDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  final int index;

  const DeliveryManDetailsScreen(this.productModel, this.index, {Key? key}) : super(key: key);

  @override
  State<DeliveryManDetailsScreen> createState() => _DeliveryManDetailsScreenState();
}

class _DeliveryManDetailsScreenState extends State<DeliveryManDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminDashboardProvider>(context, listen: false)
        .getDistributorsDetails(decryptedText(widget.productModel.distributorsID!), widget.productModel.productId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Product Details"),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Consumer<AdminDashboardProvider>(
          builder: (context, dashboardProvider, child) => widget.productModel.status == 1 || widget.productModel.status == 2
              ? CustomButton(
                  btnTxt: widget.productModel.status == 1 ? 'Click here to start delivery' : "CANCEL DELIVERY",
                  radius: 0,
                  onTap: () {
                    dashboardProvider.updateProducts(widget.index, widget.productModel.status == 1 ? 2 : 1).then((value) {
                      if (value == true) {
                        Navigator.of(context).pop();
                      }
                    });
                    // dashboardProvider.captureScreenshot();
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
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
                                title: 'DISTRIBUTORS DETAILS:',
                                textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                            Divider(color: Colors.red.withOpacity(.3)),
                            customRow('ID:', dashboardProvider.distributorsModels.phone!),
                            customRow('NAME:', dashboardProvider.distributorsModels.name!),
                            customRow('ADDRESS:', dashboardProvider.distributorsModels.address!),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: Screenshot(
                controller: dashboardProvider.screenshotController,
                child: dashboardProvider.qrCodeWidget(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
}
