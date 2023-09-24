import 'package:flutter/material.dart';
import 'package:flutter_ozow/flutter_ozow.dart';
import 'package:flutter_ozow_example/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:flutter_ozow/flutter_ozow.dart';
void main() {
  runApp(const ProviderScope(child: MyApp()));
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
      home: const PaymmentHandlerWidget(),
    );
  }
}

class PaymmentHandlerWidget extends ConsumerStatefulWidget {
  const PaymmentHandlerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymmentHandlerWidgetState();
}

class _PaymmentHandlerWidgetState extends ConsumerState<PaymmentHandlerWidget> {
  final notifyUrl = 'notify_url';
  final id = '10000';
  final amount = 100.0;
  final siteCode = 'site_code';
  final key = 'private_key';
  final bankRef = 'ABC123';
  final isTest = true;
  final PaymentType type = PaymentType.order;

  bool _isLoaded = false;

  int progress = 0;

  @override
  Widget build(BuildContext context) {
    final transactionStatus = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Ozow payment',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Builder(builder: (context) {
        ///while the transaction is processing, show the FlutterOzow widget
        switch (transactionStatus.status) {
          case TransactionStatus.processing:
            return FlutterOzow(
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
              optional2: type.toString(),
              optional3: type.toString(),
              optional4: type.toString(),
              optional5: type.toString(),
            );
          case TransactionStatus.failed:
            return const Center(child: Text('Transaction failed'));
          case TransactionStatus.cancelled:
            return const Center(child: Text('Transaction cancelled'));
          default:
            return const Center(child: Text('Transaction pending'));
        }
      })

      ///add the [FlutterOzow] widget to your body
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ///update the transaction status
          ref.read(transactionProvider.notifier).updateStatus();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
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

enum TransactionStatus {
  processing,
  pending,
  success,
  failed,
  cancelled,
}

TransactionStatus transactionStatusFromString(String status) {
  switch (status) {
    case 'success':
      return TransactionStatus.success;
    case 'failed':
      return TransactionStatus.failed;
    case 'cancelled':
      return TransactionStatus.cancelled;
    case 'processing':
      return TransactionStatus.processing;
    default:
      return TransactionStatus.pending;
  }
}

class Transaction {
  final String id;
  final TransactionStatus status;

  Transaction({required this.id, required this.status});

  factory Transaction.fromMap(Map<String, dynamic> data, String id) {
    return Transaction(
      id: id,
      status: transactionStatusFromString(data['status'].toString()),
    );
  }

  Transaction copyWith({
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id,
      status: status ?? this.status,
    );
  }
}
