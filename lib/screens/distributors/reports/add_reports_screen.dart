import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/model/response/report_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddReportsScreen extends StatelessWidget {
  final String productID;

  AddReportsScreen(this.productID, {Key? key}) : super(key: key);
  final TextEditingController titleReportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
        builder: (context, adminDashboardProvider, child) => Scaffold(
              appBar: buildAppBar("Add Reports"),
              backgroundColor: Colors.white,
              bottomNavigationBar: SizedBox(
                height: 50,
                child: adminDashboardProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        btnTxt: 'Submit',
                        onTap: () {
                          ReportModels reportModels = ReportModels(
                              reportID: DateTime.now().microsecondsSinceEpoch.toString(),
                              productID: productID,
                              description: encryptedText(titleReportController.text),
                              status: 0);

                          adminDashboardProvider.addReport(reportModels, context).then((value) {
                            if (value == true) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        radius: 0,
                      ),
              ),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  CustomTextField(
                    hintText: 'Write here ...... ',
                    maxLines: null,
                    verticalSize: 15,
                    controller: titleReportController,
                    isCancelShadow: true,
                  )
                ],
              ),
            ));
  }
}
