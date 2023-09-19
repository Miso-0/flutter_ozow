import 'package:flutter/material.dart';

//import 'package:flutter_ozow/flutter_ozow.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum PaymentType {
  order,
  deposit,
  payment,
  transfer;

  @override
  String toString() {
    switch (this) {
      case PaymentType.order:
        return 'Order';
      case PaymentType.deposit:
        return 'Deposit';
      case PaymentType.payment:
        return 'Payment';
      case PaymentType.transfer:
        return 'Transfer';
      default:
        return 'Order';
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final notifyUrl = 'some_url_to_your_awesome_backend';
  final id = 'some_unique_id';
  final amount = 100.0;
  final siteCode = 'some_site_code';
  final key = 'some_key';
  final bankRef = 'ABC123';
  final isTest = true;
  final PaymentType type = PaymentType.order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      ///add the [FlutterOzow] widget to your body
      body: FlutterOzow(
        transactionId: id,
        privateKey: key,
        siteCode: siteCode,
        bankRef: bankRef,
        amount: amount,
        isTest: isTest,
        successUrl: notifyUrl,
        errorUrl: notifyUrl,
        cancelUrl: notifyUrl,
        notifyUrl: notifyUrl,
        optional1: type.toString(),
      ),
    );
  }
}
