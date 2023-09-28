// import 'dart:convert';
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/models/status.dart';
import 'package:flutter_ozow/src/widgets/flutter_ozow_internal.dart';

/// The `FlutterOzow` widget integrates Ozow payment gateway through a WebView.
///
/// This widget utilizes [webview_flutter] to render a web page that assists
/// with completing payments via the Ozow payment gateway.
/// More information can be found at https://ozow.com.
class FlutterOzow extends StatelessWidget {
  FlutterOzow({
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
    this.customer,
    this.optional1,
    this.optional2,
    this.optional3,
    this.optional4,
    this.optional5,
    this.onComplete,
    this.width,
    this.height,
  });

  /// Put your desired width and height for the
  final double? width;
  final double? height;

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

  ///The customer’s name or identifier.
  final String? customer;

  /// Flag to indicate whether this is a test transaction.
  final bool isTest;

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

  ///A callback function that
  final void Function(OzowStatus)? onComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.sizeOf(context).width,
      height: height ?? MediaQuery.sizeOf(context).height,
      child: FlutterOzowInternal(
        transactionId: transactionId,
        privateKey: privateKey,
        apiKey: apiKey,
        siteCode: siteCode,
        bankRef: bankRef,
        amount: amount,
        isTest: isTest,
        notifyUrl: notifyUrl,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
        errorUrl: errorUrl,
        customer: customer,
        optional1: optional1,
        optional2: optional2,
        optional3: optional3,
        optional4: optional4,
        optional5: optional5,
        onComplete: onComplete,
      ),
    );
  }
}
