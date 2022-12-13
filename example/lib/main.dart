import 'package:example/helpers/custom_button.dart';
import 'package:example/helpers/themes_colors.dart';
import 'package:example/screens/business_to_business.dart';
import 'package:example/screens/business_to_customer.dart';
import 'package:example/screens/check_transaction.dart';
import 'package:example/screens/customer_to_business.dart';
import 'package:example/screens/utilities/utilities_main.dart';
import 'package:example/screens/verify_transaction.dart';
import 'package:example/utils/init_services.dart';
import 'package:example/utils/utils_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:get/get.dart';
import 'package:sasapay_sdk/sasapay_sdk.dart';
import 'package:sasapay_sdk/utils/helper_enums_consts.dart';
import 'package:sasapay_sdk/models/bank_model.dart';

void main() async {
  sasaPayServicesInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter SASA PAY SDK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  SasaPay sasaPay = Get.find<SasaPay>();

  Map<String, dynamic> response = {};
  bool loading = false;
  registerConfirmationUrl() async {
    setState(() {
      loading = true;
      response = {"Registering call back url...": "...."};
    });

    var resp = await sasaPay.registerConfirmationUrl(
      merchantCode: MERCHANT_CODE,
      confirmationCallbackURL: CALL_BACK_URL,
    );

    setState(() {
      response = resp?.data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColor.blueColor.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: CustomColor.appBarColor,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height * 1.2,
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Visibility(
                      visible: loading,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => Customer2Business(),
                      );
                    },
                    label: "CUSTOMER to Business.",
                  ),
                  SizedBox(
                    height: height / 33,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => Business2Customer(),
                      );
                    },
                    label: "BUSINESS to Customer.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => Business2Business(),
                      );
                    },
                    label: "BUSINESS to BUSINESS.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    label: "Get Merchant Account Balance.",
                    onPressed: () async {
                      setState(() {
                        loading = true;
                        response = {"Getting account balance...": "...."};
                      });

                      var resp = await sasaPay.queryMerchantAccountBalance(
                          merchantCode: MERCHANT_CODE);

                      setState(() {
                        response = resp?.data;
                        loading = false;
                      });
                    },
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 13, 103, 167),
                      Color(0xff005492),
                      Color(0xff003359),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => CheckTransaction(),
                      );
                    },
                    label: "CHECK transaction Status.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => VerifyTransaction(),
                      );
                    },
                    label: "Verify a transaction.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                      label: "Register confirmation url",
                      onPressed: () {
                        registerConfirmationUrl();
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomElevatedButton(
                      label: "Get bank channel codes",
                      onPressed: () async {
                        setState(() {
                          loading = true;
                          response = {"Getting bank codes": "...."};
                        });
                        List<BanksChannelCode?> result =
                            SasaPay.getBanksCodes();
                        setState(() {
                          loading = false;
                          response = Map.fromIterable(
                            result,
                            key: (v) => v.bankName,
                            value: (v) => v.bankCode,
                          );
                          ;
                        });
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: CustomColor.blueColor,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => utilitiesMainPage(),
                      );
                    },
                    label: "UTILITIES.",
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 13, 103, 167),
                      Color(0xff005492),
                      Color(0xff003359),
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  JsonView.map(response),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
