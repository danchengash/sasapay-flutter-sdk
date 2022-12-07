import 'dart:convert';

import 'package:example/helpers/custom_button.dart';
import 'package:example/screens/process_payment.dart';
import 'package:example/utils/utils_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:example/helpers/themes_colors.dart';
import 'package:get/get.dart';
import 'package:select_card/select_card.dart';
import 'package:sasapay_sdk/helper_functions.dart';
import 'package:sasapay_sdk/initialize_sdk.dart';
import 'package:sasapay_sdk/models/bank_model.dart';

class CheckTransaction extends StatefulWidget {
  CheckTransaction({Key? key}) : super(key: key);

  @override
  State<CheckTransaction> createState() => _CheckTransactionState();
}

class _CheckTransactionState extends State<CheckTransaction> {
  int _selectedIndex = 0;
  TextEditingController transIdController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  SasaPay sasaPay = Get.find<SasaPay>();

  int? networkcode;
  Map<String, dynamic> response = {};

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: height / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Check transaction status",
                              style: TextStyle(
                                  fontSize: height / 45,
                                  fontFamily: 'Gilroy Bold'),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 50,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 20),
                            child: Text(
                              "Transaction checkout id.",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 43,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 60,
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 18),
                        child: Container(
                          color: Colors.transparent,
                          height: height / 15,
                          child: TextFormField(
                            autofocus: false,
                            controller: transIdController,
                            validator: (v) {
                              if (v!.length < 1) {
                                return "Enter valid id";
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              fontSize: height / 50,
                              color: Colors.blue,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Enter checkout id.",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: height / 60),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      SizedBox(
                        height: height / 50,
                      ),
                      loading
                          ? const CircularProgressIndicator()
                          : CustomElevatedButton(
                              width: width / 1.6,
                              onPressed: (() async {
                                try {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                      response = {"processing..": ".."};
                                    });

                                    var resp =
                                        await sasaPay.checkTransactionStatus(
                                      merchantCode: MERCHANT_CODE,
                                      checkoutId: transIdController.text.trim(),
                                    );

                                    setState(() {
                                      loading = false;
                                      response = resp?.data;
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    loading = false;
                                  });
                                } finally {
                                  setState(() {});
                                }
                              }),
                              label: 'submit',
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: JsonView.map(response),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
