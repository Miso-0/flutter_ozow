import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

final transactionProvider = StreamProvider.autoDispose
    .family<Transaction, String>((ref, transactionId) {
  return FirebaseFirestore.instance
      .collection('transactions')
      .doc(transactionId)
      .snapshots()
      .map((snapshot) => Transaction.fromMap(
          snapshot.data() as Map<String, dynamic>, snapshot.id));
});

class _PaymmentHandlerWidgetState extends ConsumerState<PaymmentHandlerWidget> {
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
    final AsyncValue<Transaction> transactionStatus =
        ref.watch(transactionProvider(id));

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

      ///add the [FlutterOzow] widget to your body
      body: transactionStatus.when(
        data: (status) {
          ///while the transaction is processing, show the FlutterOzow widget
          switch (status.status) {
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
              );
            case TransactionStatus.failed:
              return const Center(child: Text('Transaction failed'));
            case TransactionStatus.cancelled:
              return const Center(child: Text('Transaction cancelled'));

            default:
              return const Center(child: Text('Transaction pending'));
          }
        },
        error: (error, stackTrace) => const Center(child: Text('Error')),
        loading: () => const Center(child: CircularProgressIndicator()),
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
}
