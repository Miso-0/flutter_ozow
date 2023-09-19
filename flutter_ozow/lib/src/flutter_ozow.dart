import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// The `FlutterOzow` widget integrates Ozow payment gateway through a WebView.
///
/// This widget utilizes [webview_flutter] to render a web page that assists
/// with completing payments via the Ozow payment gateway.
/// More information can be found at https://ozow.com.
class FlutterOzow extends StatelessWidget {
  const FlutterOzow({
    super.key,
    required this.transactionId,
    required this.privateKey,
    required this.siteCode,
    required this.bankRef,
    required this.amount,
    required this.isTest,
    this.notifyUrl,
    this.successUrl,
    this.errorUrl,
    this.cancelUrl,
    this.customName,
    this.optional1,
    this.optional2,
    this.optional3,
    this.optional4,
    this.optional5,
  });

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

  /// Reference string that will appear on the user's bank statement.
  final String bankRef;

  /// The amount to be paid for the transaction.
  final double amount;

  /// Flag to indicate whether this is a test transaction.
  final bool isTest;

  /// URLs for various payment outcomes. Ozow sends notifications to these URLs.
  ///
  /// These are optional and can be the same URL, where your backend will handle
  /// the different transaction statuses.
  final String? notifyUrl;
  final String? successUrl;
  final String? errorUrl;
  final String? cancelUrl;
  final String? customName;

  /// Additional optional parameters that will be sent back to your backend.
  ///
  /// These can be anything you need, like API keys for authenticating Ozow's response.
  final String? optional1;
  final String? optional2;
  final String? optional3;
  final String? optional4;
  final String? optional5;

  /// Constructs the URI and request body.
  ///
  /// This prepares the data needed for making the POST request.
  ({Uri uri, Uint8List body}) getContents() {
    //after hosting th php file on your server, replace the baseUrl with the url to the php file
    final String baseUrl =
        'https://flutter-ozow.azurewebsites.net/?amount=${amount.toStringAsFixed(2)}&transactionId=$transactionId';
    // Prepare the body of the POST request.
    final body = {
      'transactionId': transactionId.toString(),
      'siteCode': siteCode,
      'bankRef': bankRef,
      'amount': amount.toStringAsFixed(2),
      'privateKey': privateKey,
      'isTest': isTest.toString(),
      'notifyUrl': notifyUrl,
      'successUrl': successUrl,
      'errorUrl': errorUrl,
      'cancelUrl': cancelUrl,
      'customName': customName,
      'optional1': optional1,
      'optional2': optional2,
      'optional3': optional3,
      'optional4': optional4,
      'optional5': optional5,
    };

    // Convert the body to a byte list.
    final bodyList = Uint8List.fromList(utf8.encode(json.encode(body)));
    // Parse the URL to a URI.
    final uri = Uri.parse(baseUrl);

    return (uri: uri, body: bodyList);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      // Initialize the WebView and its settings.
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(
          method: LoadRequestMethod.post,
          getContents().uri,
          body: getContents().body,
        ),
    );
  }
}
