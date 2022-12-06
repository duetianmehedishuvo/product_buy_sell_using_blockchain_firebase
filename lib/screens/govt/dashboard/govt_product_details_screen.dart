import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class GovtProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;

  const GovtProductDetailsScreen(this.productModel, {Key? key}) : super(key: key);

  @override
  State<GovtProductDetailsScreen> createState() => _GovtProductDetailsScreenState();
}

class _GovtProductDetailsScreenState extends State<GovtProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminDashboardProvider>(context, listen: false).updateProductID(widget.productModel.productId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Product Details"),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Consumer<AdminDashboardProvider>(
          builder: (context, dashboardProvider, child) => widget.productModel.govtVerifiedStatus == false
              ? CustomButton(
                  btnTxt: 'Click here to Verified Product',
                  radius: 0,
                  onTap: () {
                    dashboardProvider.verifiedByGovernmentProduct().then((value) {
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
            customRow2('Government Verified:', widget.productModel.govtVerifiedStatus!),
            Divider(color: Colors.black.withOpacity(.1)),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: Screenshot(
                controller: dashboardProvider.screenshotController,
                child: dashboardProvider.qrCodeWidget(),
              ),
            ),
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
