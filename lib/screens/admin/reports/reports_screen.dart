import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/report_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/screens/admin/reports/report_details_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(title: 'All Reports', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(report).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (!snapshots.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshots.data!.docs.isEmpty) {
                return Center(
                    child: Text(
                  'No data available',
                  style: sfProStyle600SemiBold.copyWith(fontSize: 16),
                ));
              } else {
                return ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    ReportModels reportModels = ReportModels.fromJson(snapshots.data!.docs[index].data() as Map<String, dynamic>);

                    return InkWell(
                      onTap: () {
                        Helper.toScreen(context, ReportDetailsScreen(reportModels));
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
                                      title: 'Product ID: ${decryptedText(reportModels.productID!)}',
                                      color: Colors.black,
                                      textStyle: sfProStyle700Bold.copyWith(fontSize: 16)),
                                  const SizedBox(height: 3),
                                  CustomText(
                                    title: 'USER ID: ${reportModels.userID!}',
                                    color: Colors.black,
                                    textStyle: sfProStyle400Regular.copyWith(color: Colors.black.withOpacity(.9), fontSize: 15),
                                  ),
                                  const SizedBox(height: 3),
                                  CustomText(
                                    title: 'Status: ${reportModels.status == 0 ? "NEW" : "Solved"}',
                                    textStyle: sfProStyle700Bold.copyWith(
                                        color: reportModels.status == 0 ? colorPrimary : Colors.green, fontSize: 16),
                                  ),
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
