import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class AddProductScreen2 extends StatefulWidget {
  const AddProductScreen2({Key? key}) : super(key: key);

  @override
  State<AddProductScreen2> createState() => _AddProductScreen2State();
}

class _AddProductScreen2State extends State<AddProductScreen2> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminDashboardProvider>(context, listen: false).getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(title: 'Product assign', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Consumer<AdminDashboardProvider>(
        builder: (context, dashboardProvider, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(.1), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                    ],
                    borderRadius: BorderRadius.circular(7)),
                child: Column(
                  children: [
                    CustomText(title: 'Select Distributors:', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                    DropdownButton(
                      value: dashboardProvider.selectDistributors,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dashboardProvider.distributorsLists.map((UserModels items) {
                        return DropdownMenuItem(
                            value: items,
                            child: CustomText(
                                title: '${items.name!} -(${items.phone})',
                                color: Colors.black,
                                textStyle: sfProStyle500Medium.copyWith(color: Colors.black, fontSize: 15)));
                      }).toList(),
                      onChanged: (UserModels? newValue) {
                        dashboardProvider.changeDistributors(newValue!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(.1), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                    ],
                    borderRadius: BorderRadius.circular(7)),
                child: Column(
                  children: [
                    CustomText(title: 'Select Deliveryman:', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                    DropdownButton(
                      value: dashboardProvider.selectDeliveryMan,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dashboardProvider.deliveryManLists.map((UserModels items) {
                        return DropdownMenuItem(
                            value: items,
                            child: CustomText(
                                title: '${items.name!} -(${items.phone})',
                                color: Colors.black,
                                textStyle: sfProStyle500Medium.copyWith(color: Colors.black, fontSize: 15)));
                      }).toList(),
                      onChanged: (UserModels? newValue) {
                        dashboardProvider.changeDeliveryMan(newValue!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              CustomButton(
                btnTxt: 'Assign',
                onTap: () {
                  dashboardProvider.assignProduct(context).then((value) {
                    if (value == true) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
// I am nothing without Allah.
