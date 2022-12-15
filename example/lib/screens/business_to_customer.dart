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

class Business2Customer extends StatefulWidget {
  Business2Customer({Key? key}) : super(key: key);

  @override
  State<Business2Customer> createState() => _Business2CustomerState();
}

class _Business2CustomerState extends State<Business2Customer> {
  int _selectedIndex = 0;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  SasaPay sasaPay = Get.find<SasaPay>();

  int? networkcode;
  Map<String, dynamic> response = {};

  List<BanksChannelCode?> banks = [];
  BanksChannelCode? selectedBank;

  bool loading = false;

  @override
  void initState() {
    banks = SasaPay.getBanksCodes();
    super.initState();
  }

  String? selectedReason;
  bool showprocessPayment = false;

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
                              "Business to Customer transfer",
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
                              "Transfer To:",
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
                      Container(
                        height: height / 17,
                        width: width / 1.12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: DropdownButton(
                          underline: const SizedBox(),
                          value: selectedBank,
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: width / 4),
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                color: CustomColor.getdarkcolor,
                              ),
                            ],
                          ),

                          // Array list of items
                          items: banks.map((docitems) {
                            return DropdownMenuItem(
                              value: docitems,
                              child: Row(
                                children: [
                                  SizedBox(width: width / 50),
                                  Text(
                                    docitems!.bankName,
                                    style: TextStyle(fontSize: height / 60),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (newValue) {
                            setState(() {
                              selectedBank = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: height / 35,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width / 18,
                          ),
                          Text(
                            "Account Number",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: height / 50,
                            ),
                          ),
                        ],
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
                            keyboardType: TextInputType.number,
                            controller: phoneNumberController,
                            validator: (v) {
                              if (v!.length < 9) {
                                return "Enter valid mobile number";
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              fontSize: height / 50,
                              color: Colors.blue,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: IconButton(
                                  padding: const EdgeInsets.only(right: 0),
                                  tooltip: "Pick from contacts.",
                                  icon: const Icon(Icons.search),
                                  onPressed: () async {
                                    var number = phoneNumberController.text;
                                    bool hasPermission =
                                        await FlutterContactPicker
                                            .hasPermission();
                                    if (hasPermission) {
                                      final PhoneContact contact =
                                          await FlutterContactPicker
                                              .pickPhoneContact();
                                      var number =
                                          contact.phoneNumber?.number ?? "";
                                      if (contact.phoneNumber!.number!
                                          .startsWith("+254")) {
                                        formKey.currentState!.reset();
                                        setState(() {
                                          var numb = number.split("+254")[1];
                                          numb = "0" + numb;
                                          phoneNumberController.text =
                                              numb.replaceAll(" ", "").trim();
                                        });
                                      } else {
                                        formKey.currentState!.reset();
                                        setState(() {
                                          var numb = number
                                              .replaceAll(" ", "")
                                              .replaceAll("(", "")
                                              .replaceAll(")", "")
                                              .replaceAll("-", "");
                                          phoneNumberController.text =
                                              numb.trim();
                                        });
                                      }
                                    } else {
                                      await FlutterContactPicker
                                          .requestPermission();
                                      final PhoneContact contact =
                                          await FlutterContactPicker
                                              .pickPhoneContact();
                                      if (contact.phoneNumber!.number!
                                          .startsWith("+254")) {
                                        formKey.currentState!.reset();
                                        setState(() {
                                          var numb = number.split("+254")[1];
                                          numb = "0" + numb;
                                          phoneNumberController.text =
                                              numb.replaceAll(" ", "").trim();
                                        });
                                      } else {
                                        formKey.currentState!.reset();
                                        setState(() {
                                          var numb = number
                                              .replaceAll(" ", "")
                                              .replaceAll("(", "")
                                              .replaceAll(")", "")
                                              .replaceAll("-", "");
                                          phoneNumberController.text =
                                              numb.trim();
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                              filled: true,
                              hintText: "Enter Mobile Number",
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height / 100,
                                    horizontal: height / 70),
                                child: const Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                              ),
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
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 20),
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                color: CustomColor.getdarkcolor,
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 43,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 20),
                        child: Container(
                          height: height / 8,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: CustomColor.blueColor.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height / 50,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width / 20,
                                  ),
                                  Text(
                                    "Enter amount.",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      fontSize: height / 50,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 20),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: CustomColor.getdarkcolor,
                                      fontSize: height / 40),
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  controller: amountController,
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Enter valid amount";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: "KES 0",
                                      hintStyle: TextStyle(
                                          fontSize: height / 30,
                                          color: CustomColor.getdarkcolor
                                              .withOpacity(0.4),
                                          fontFamily: 'Gilroy Bold')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 20),
                        child: Container(
                          color: Colors.transparent,
                          width: width,
                          height: height / 17,
                          child: TextField(
                            controller: reasonController,
                            autofocus: false,
                            onChanged: (value) {
                              selectedReason = value.trim();
                            },
                            style: TextStyle(
                              fontSize: height / 50,
                              color: CustomColor.getdarkcolor,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: CustomColor.getdarkwhitecolor,
                              hintText: "Reason(optional)",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: height / 60),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
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
                        height: height / 30,
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
                                    final amount =
                                        double.tryParse(amountController.text);
                                    var resp = await sasaPay.business2Customer(
                                        merchantCode: MERCHANT_CODE,
                                        amount: amount!,
                                        receiverNumber:phoneNumberController.text,
                                        channelCode: selectedBank!.bankCode,
                                        callBackURL: CALL_BACK_URL,
                                        transactionDesc: selectedReason,
                                        accountReference:phoneNumberController.text,
                                        );

                                    setState(() {
                                      loading = false;
                                      response = resp?.data;
                                      showprocessPayment = response["status"];
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
                      Visibility(
                        visible: showprocessPayment,
                        child: CustomElevatedButton(
                          onPressed: () {
                            Get.to(() => ProcessPaymentPage(
                                checkoutRequestId:
                                    response["CheckoutRequestID"]));
                          },
                          label: "Process Payment",
                        ),
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
