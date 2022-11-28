import 'package:flutter/material.dart';
import 'package:sasapay_sdk/sasapay_sdk.dart';
import 'package:sasapay_sdk/utils/helper_enums.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String response = "";
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text("test"),
            ),
            Text(response),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SasaPay sasaPay = SasaPay(
            clientId: "yHKopXUeZNyxFqAyIyTNBu85v6SzLOoCepipa2Bl",
            clientSecret:
                "d2Our4qLYvo38aPHeqRt2lfUMAfwXyqoSG2UFZgWjZLoTNi6MVoAM72cTbEwB7U9dYSiXZiH0ZOtfX0c94dEVNM5mRK7Rgehm5padmcc8wdNKjt5JlLJ6KJatwMDWyMW",
            environment: Environment.Testing,
          );
          final resp = await sasaPay.registerConfirmationUrl(
            merchantCode: 600980,
            confirmationCallbackURL: "https://8c54-41-90-115-26.eu.ngrok.io",
          );
          print(resp);
          setState(() {
            response = resp?.data?.toString() ?? "";
          });
        },
        tooltip: 'Test',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
