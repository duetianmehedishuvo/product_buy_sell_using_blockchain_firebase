import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/screens/admin/user_details/user_details_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:product_buy_sell/widgets/custom_text.dart';

class DistributorsScreen extends StatelessWidget {
  const DistributorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(title: 'Distributors', textStyle: sfProStyle600SemiBold.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: colorPrimary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(user).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (!snapshots.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshots.data!.docs.isEmpty) {
                return const Text('No data available');
              } else {
                return ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    UserModels user = UserModels.fromJson(snapshots.data!.docs[index].data() as Map<String, dynamic>);

                    if (user.userType == 0) {
                      return InkWell(
                        onTap: (){
                          Helper.toScreen(context, UserDetailsScreen(user));
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
                                        title: 'Name: ${user.name}',
                                        color: Colors.black,
                                        textStyle: sfProStyle700Bold.copyWith(fontSize: 16)),
                                    const SizedBox(height: 3),
                                    CustomText(
                                      title: 'Phone: ${user.phone}',
                                      color: Colors.black,
                                      textStyle: sfProStyle400Regular.copyWith(color: Colors.black.withOpacity(.9), fontSize: 15),
                                    ),
                                    const SizedBox(height: 3),
                                    CustomText(
                                      title: 'Address: ${user.address}',
                                      color: Colors.black87,
                                      textStyle: sfProStyle400Regular.copyWith(color: Colors.black87, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward, color: Colors.black)
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                );
              }
            }
          }),
    );
  }
}
