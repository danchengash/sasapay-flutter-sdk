import 'dart:convert';

import 'package:example/helpers/custom_button.dart';
import 'package:example/utils/utils_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:example/helpers/themes_colors.dart';
import 'package:select_card/select_card.dart';
import 'package:sasapay_sdk/helper_functions.dart';
import 'package:sasapay_sdk/initialize_sdk.dart';

class Customer2Business extends StatefulWidget {
  Customer2Business({required this.sasaPay, Key? key}) : super(key: key);

  SasaPay sasaPay;

  @override
  State<Customer2Business> createState() => _Customer2BusinessState();
}

class _Customer2BusinessState extends State<Customer2Business> {
  int _selectedIndex = 0;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int? networkcode;
  String? response;

  List<String?> images = [
    "assets/images/sasapay.png",
    "assets/images/mpesa_icon.png",
    "assets/images/airtel_money.jpeg",
    "assets/images/t_kash.png",
  ];

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  String? selectedReason;

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
                              "Customer to business transfer",
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 43),
                        child: SizedBox(
                          width: width / 0.35,
                          child: SelectGroupCard(context,
                              titles: const [
                                "Sasa Pay",
                                "Mpesa",
                                "Airtel",
                                "Tkash"
                              ],
                              imageSourceType: ImageSourceType.asset,
                              images: images,
                              contents: const [
                                "Sasa Pay",
                                "Mpesa",
                                "Airtel",
                                "Tkash"
                              ],
                              cardBackgroundColor:
                                  const Color.fromARGB(255, 135, 200, 246),
                              cardSelectedColor:
                                  const Color.fromARGB(255, 172, 0, 32),
                              titleTextColor:
                                  const Color.fromARGB(255, 0, 15, 28),
                              contentTextColor: Colors.black87, onTap: (title) {
                            setState(() {
                              networkcode =
                                  SasaPay.getNetworkCode(networkTitle: title);
                            });

                            debugPrint(networkcode.toString());
                          }),
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
                                color: notifire.getdarkscolor,
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
                              color: notifire.blueColor.withOpacity(0.1),
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
                                    "Enter amount",
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
                                      color: notifire.getdarkscolor,
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
                                          color: notifire.getdarkscolor
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
                              color: notifire.getdarkscolor,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: notifire.getdarkwhitecolor,
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
                          ? CircularProgressIndicator()
                          : CustomElevatedButtonWithChild(
                              width: width / 1.6,
                              onPressed: (() async {
                                try {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                      response = "Registering call back url";
                                    });

                                    var resp = await widget.sasaPay
                                        .registerConfirmationUrl(
                                      merchantCode: 600980.toString(),
                                      confirmationCallbackURL:
                                          "https://6fb9-41-90-115-26.eu.ngrok.io",
                                    );
                                    print(resp);
                                    setState(() {
                                      response = resp?.data?.toString() ?? "";
                                    });
                                    // final amount =
                                    //     double.tryParse(amountController.text);
                                    // resp = await widget.sasaPay
                                    //     .customer2BusinessPhoneNumber(
                                    //         merchantCode: MERCHANT_CODE,
                                    //         networkCode: networkcode.toString(),
                                    //         transactionDesc:
                                    //             reasonController.text,
                                    //         phoneNumber:
                                    //             phoneNumberController.text,
                                    //         accountReference:
                                    //             phoneNumberController.text,
                                    //         amount: amount!,
                                    //         callBackURL:
                                    //             "https://6fb9-41-90-115-26.eu.ngrok.io");
                                    setState(() {
                                      loading = false;
                                      response = resp?.data.toString();
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
                      Text(response ?? '')
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
