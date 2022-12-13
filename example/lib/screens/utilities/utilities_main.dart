import 'package:example/helpers/custom_button.dart';
import 'package:example/helpers/themes_colors.dart';
import 'package:example/screens/business_to_business.dart';
import 'package:example/screens/business_to_customer.dart';
import 'package:example/screens/check_transaction.dart';
import 'package:example/screens/customer_to_business.dart';
import 'package:example/screens/verify_transaction.dart';
import 'package:example/utils/init_services.dart';
import 'package:example/utils/utils_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:get/get.dart';
import 'package:sasapay_sdk/sasapay_sdk.dart';
import 'package:sasapay_sdk/utils/helper_enums_consts.dart';
import 'package:sasapay_sdk/models/bank_model.dart';

class utilitiesMainPage extends StatefulWidget {
  const utilitiesMainPage({
    super.key,
  });

  @override
  State<utilitiesMainPage> createState() => _utilitiesMainPageState();
}

class _utilitiesMainPageState extends State<utilitiesMainPage> {
  int _counter = 0;

  SasaPay sasaPay = Get.find<SasaPay>();

  Map<String, dynamic> response = {};
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColor.blueColor.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: CustomColor.appBarColor,
        centerTitle: true,
        title: const Text("UTILITIES."),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height * 1.2,
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      const TabBar(tabs: [
                        Tab(
                          text: "Airtime",
                        ),
                        Tab(
                          text: "Bills",
                        ),
                        Tab(
                          text: "TV payment",
                        ),
                        Tab(
                          text: "KPLC tokens",
                        )
                      ]),
                      SizedBox(
                        height: height,
                        width: width,
                        child: const DefaultTextStyle(
                          style: TextStyle(color: Colors.white),
                          child: TabBarView(children: [
                            Center(child: Text("Coming sooon feature")),
                            Center(child: Text("Coming sooon feature")),
                            Center(
                                child: Text("Coming sooon feature,stay tuned")),
                            Center(child: Text("Coming sooon feature")),
                          ]),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
