import 'package:flutter/material.dart';
import 'package:flutter_ozow/flutter_ozow.dart';
import 'package:flutter_ozow/src/domain/entities/banks.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class FlutterOzowSelectBank extends StatefulWidget {
  FlutterOzowSelectBank({
    super.key,
    required this.transactionId,
    required this.privateKey,
    required this.apiKey,
    required this.siteCode,
    required this.bankRef,
    required this.amount,
    required this.isTest,
    required this.notifyUrl,
    this.successUrl,
    this.errorUrl,
    this.cancelUrl,
    this.optional1,
    this.optional2,
    this.optional3,
    this.optional4,
    this.optional5,
    this.onComplete,
    this.onError,
  });

  /// Put your desired width and height for the widget.
  // final double? width;
  // final double? height;

  /// Unique transaction ID or order number generated from your backend.
  ///
  /// This will be used as a reference for each payment transaction.
  final Object transactionId;

  /// Your Ozow site code obtained from your Ozow merchant profile.
  ///
  /// Located under "SITES" on your merchant profile.
  final String siteCode;

  /// Your Ozow private key obtained from your Ozow merchant profile.
  ///
  /// Located under Merchant Details on your merchant profile.
  final String privateKey;

  ///
  final String apiKey;

  /// Reference string that will appear on the user's bank statement.
  final String bankRef;

  /// The amount to be paid for the transaction.
  final double amount;

  /// Flag to indicate whether this is a test transaction.
  final bool isTest;

  ///If there is a specific bank you want to use, you can specify it here.
  // final Banks? selectedBank;

  ///URLs for various payment outcomes. Ozow sends notifications to these URLs.
  ///The URL that the notification result should be posted to.
  ///The result will post regardless of the outcome of the transaction.
  final String notifyUrl;

  /// The URL to which the redirect result should be posted to if the payment is successful.
  /// This is also be the page the customer gets redirected to.
  /// This URL can also be set for the applicable merchant site in the merchant admin section. If a value is set
  /// in the merchant admin and sent in the post, the posted value will be redirected to if the payment was successful.
  String? successUrl;
  ////The URL to which the redirect result should be posted to if the customer cancels the payment.
  ///This is also the page the customer will be redirected to.
  ///This URL can also be set for the applicable merchant site in the merchant admin section.
  ///If a value is set in the merchant admin and sent in the post,
  ///The posted value will be redirected to if the payment is cancelled.
  String? cancelUrl;

  ///The URL to which the redirect result should be posted if an error occurs
  ///while trying to process the payment. This is also the page the customer will be redirected to.
  /// This URL can also be set for the applicable merchant site in the merchant admin section.
  /// If a value is set in the merchant admin and sent in the post,
  /// the posted value will be redirected to if an error occurred while processing the payment.
  String? errorUrl;

  ///Optional fields the merchant can post for additional information
  ///They would need passed back in the response.
  ///These are also stored with the transaction details by Ozow,
  ///And can be useful for filtering transactions in the merchant admin section.
  final String? optional1;
  final String? optional2;
  final String? optional3;
  final String? optional4;
  final String? optional5;

  ///A callback function that is excuted when the transaction is complete
  final void Function(OzowTransaction?, OzowStatus)? onComplete;
  final void Function(String errorMessage, WebResourceErrorType? errorType)?
      onError;

  @override
  State<FlutterOzowSelectBank> createState() => _FlutterOzowSelectBankState();
}

class _FlutterOzowSelectBankState extends State<FlutterOzowSelectBank> {
  Banks? selectedBank;

  void setSelectedBank(Banks? bank) {
    setState(() {
      selectedBank = bank;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: () {
      if (selectedBank == null) {
        ListView(
          children: [
            const Text('Select Bank'),
            for (final b in Banks.values)
              ListTile(
                title: Text(b.toString()),
                onTap: () {
                  setSelectedBank(b);
                },
              )
          ],
        );
      } else {
        return FlutterOzow(
          transactionId: widget.transactionId,
          siteCode: widget.siteCode,
          privateKey: widget.privateKey,
          apiKey: widget.apiKey,
          bankRef: widget.bankRef,
          amount: widget.amount,
          isTest: widget.isTest,
          notifyUrl: widget.notifyUrl,
          successUrl: widget.successUrl,
          cancelUrl: widget.cancelUrl,
          errorUrl: widget.errorUrl,
          optional1: widget.optional1,
          optional2: widget.optional2,
          optional3: widget.optional3,
          optional4: widget.optional4,
          optional5: widget.optional5,
          onComplete: widget.onComplete,
          onError: widget.onError,
          selectedBank: selectedBank!.bankId(),
        );
      }
    }());
  }
}
