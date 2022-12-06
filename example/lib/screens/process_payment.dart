import 'package:example/utils/utils_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:get/instance_manager.dart';
import 'package:pinput/pinput.dart';
import 'package:sasapay_sdk/helper_functions.dart';
import 'package:sasapay_sdk/initialize_sdk.dart';

class ProcessPaymentPage extends StatefulWidget {
  ProcessPaymentPage({required this.checkoutRequestId, super.key});
  String checkoutRequestId;

  @override
  State<ProcessPaymentPage> createState() => _ProcessPaymentPageState();
}

class _ProcessPaymentPageState extends State<ProcessPaymentPage> {
  final sasapay = Get.find<SasaPay>();

  Map<String, dynamic> response = {};
  bool loading = false;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 123, 186, 237),
      border: Border.all(color: const Color.fromARGB(255, 1, 30, 54)),
      borderRadius: BorderRadius.circular(16),
    ),
  );
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Process Payment"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: height / 7,
              ),
              const Text("Enter the code sent to the number."),
              SizedBox(
                height: height / 18,
              ),
              Pinput(
                length: 6,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                defaultPinTheme: defaultPinTheme,
                showCursor: true,
                onCompleted: (pin) async {
                  setState(() {
                    loading = true;
                    response = {"processing..": ".."};
                  });
                  var res = await sasapay.processC2Bpayment(
                    merchantCode: MERCHANT_CODE,
                    checkoutRequestID: widget.checkoutRequestId,
                    verificationCode: pin,
                  );
                  setState(() {
                    response = res?.data;
                    loading = false;
                  });
                },
              ),
              Visibility(
                visible: loading,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: JsonView.map(response),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
