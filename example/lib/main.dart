import 'package:example/helpers/custom_button.dart';
import 'package:example/screens/customer_to_business.dart';
import 'package:example/utils/init_services.dart';
import 'package:example/utils/utils_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:get/get.dart';
import 'package:sasapay_sdk/sasapay_sdk.dart';
import 'package:sasapay_sdk/utils/helper_enums.dart';

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
      merchantCode: 600980.toString(),
      confirmationCallbackURL: CALL_BACK_URL,
    );

    setState(() {
      response = resp?.data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomElevatedButton(
                onPressed: () {
                  Get.to(
                    () => Customer2Business(
                      sasaPay: sasaPay,
                    ),
                  );
                },
                label: "Customer to Business",
              ),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                  label: "Reg confirmation url",
                  onPressed: () {
                    registerConfirmationUrl();
                  }),
              const SizedBox(
                height: 30,
              ),
              JsonView.map(response),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resp = await sasaPay.registerConfirmationUrl(
            merchantCode: 600980.toString(),
            confirmationCallbackURL: CALL_BACK_URL,
          );
          print(resp);
          setState(() {
            response = resp?.data;
          });
        },
        tooltip: 'Test',
        child: const Icon(Icons.add),
      ),
    );
  }
}
