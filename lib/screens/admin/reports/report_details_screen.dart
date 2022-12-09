import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/report_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/screens/admin/product/product_details_screen.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class ReportDetailsScreen extends StatefulWidget {
  final ReportModels reportModels;

  const ReportDetailsScreen(this.reportModels, {Key? key}) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminDashboardProvider>(context, listen: false)
        .getDistributorsDetails(widget.reportModels.userID!, widget.reportModels.productID!);
    Provider.of<AdminDashboardProvider>(context, listen: false).getProducts(widget.reportModels.productID!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Report Details"),
      body: Consumer<AdminDashboardProvider>(
        builder: (context, dashboardProvider, child) => dashboardProvider.isLoading || dashboardProvider.isLoadingProduct
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                children: [
                  customRow1('REPORT ID:', widget.reportModels.reportID.toString()),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow1('PRODUCT ID:', widget.reportModels.productID.toString()),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow1('PROBLEMS:', decryptedText(widget.reportModels.description.toString())),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow1('TITLE:', decryptedText(dashboardProvider.productModel.title.toString())),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow1('Quantity:', dashboardProvider.productModel.quantity.toString()),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow1('PRICE:', dashboardProvider.productModel.quantity.toString()),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow1('MANUFACTURE DATE:', decryptedText(dashboardProvider.productModel.manufacturerDate.toString())),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow1('EXPIRED DATE:', decryptedText(dashboardProvider.productModel.expiredDate.toString())),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow2('Government Verified:', dashboardProvider.productModel.manufacturerVerifiedStatus!),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow2('Distributors Verified:', dashboardProvider.productModel.distributorsVerifiedStatus!),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow2('Retailer Verified:', dashboardProvider.productModel.retailerVerifiedStatus!),
                  Divider(color: Colors.black.withOpacity(.1)),
                  customRow3('Sell Status:', dashboardProvider.productModel.status! == 0 ? "No" : "YES"),
                  Divider(color: Colors.black.withOpacity(.1)),
                  // const SizedBox(height: 15),
                  // dashboardProvider.isLoading
                  //     ? const Center(child: CircularProgressIndicator())
                  //     : Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //             width: getAppSizeWidth(context),
                  //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                       color: Colors.grey.withOpacity(.2),
                  //                       blurRadius: 10.0,
                  //                       spreadRadius: 3.0,
                  //                       offset: const Offset(0.0, 0.0))
                  //                 ],
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 CustomText(
                  //                     title: 'DISTRIBUTORS DETAILS:',
                  //                     textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                  //                 Divider(color: Colors.red.withOpacity(.3)),
                  //                 customRow('ID:', dashboardProvider.distributorsModels.phone!),
                  //                 customRow('NAME:', dashboardProvider.distributorsModels.name!),
                  //                 customRow('ADDRESS:', dashboardProvider.distributorsModels.address!),
                  //               ],
                  //             ),
                  //           ),
                  //           const SizedBox(height: 15),
                  //           StreamBuilder(
                  //               stream: FirebaseFirestore.instance
                  //                   .collection(user)
                  //                   .doc(decryptedText(dashboardProvider.productModel.retailerID!))
                  //                   .snapshots(),
                  //               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  //                 if (!snapshot.hasData) {
                  //                   return Center(
                  //                       child: Text(
                  //                     "Delivery Man Not Found",
                  //                     textAlign: TextAlign.center,
                  //                     style: sfProStyle700Bold.copyWith(color: colorPrimary, fontSize: 16),
                  //                   ));
                  //                 }
                  //                 UserModels deliveryManModels = UserModels.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                  //                 return Container(
                  //                   width: getAppSizeWidth(context),
                  //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //                   decoration: BoxDecoration(
                  //                       color: Colors.white,
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                             color: Colors.grey.withOpacity(.2),
                  //                             blurRadius: 10.0,
                  //                             spreadRadius: 3.0,
                  //                             offset: const Offset(0.0, 0.0))
                  //                       ],
                  //                       borderRadius: BorderRadius.circular(10)),
                  //                   child: Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       CustomText(
                  //                           title: 'DELIVERY MAN DETAILS:',
                  //                           textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                  //                       Divider(color: Colors.red.withOpacity(.3)),
                  //                       customRow('ID:', deliveryManModels.phone!),
                  //                       customRow('NAME:', deliveryManModels.name!),
                  //                       customRow('ADDRESS:', deliveryManModels.address!),
                  //                     ],
                  //                   ),
                  //                 );
                  //               }),
                  //         ],
                  //       ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 200,
                    child: Screenshot(
                      controller: dashboardProvider.screenshotController,
                      child: dashboardProvider.qrCodeWidget(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  widget.reportModels.status == 0
                      ? CustomButton(
                          btnTxt: 'Solve Issue',
                          onTap: () async {
                            Navigator.of(context).pop();
                            await FireStoreDatabaseHelper.updateReports(widget.reportModels.reportID!, status: 1);
                          },
                        )
                      : const SizedBox.shrink(),
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
