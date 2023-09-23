// import 'dart:convert';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// The `FlutterOzow` widget integrates Ozow payment gateway through a WebView.
///
/// This widget utilizes [webview_flutter] to render a web page that assists
/// with completing payments via the Ozow payment gateway.
/// More information can be found at https://ozow.com.
class FlutterOzow extends StatefulWidget {
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
    this.customer,
    this.optional1,
    this.optional2,
    this.optional3,
    this.optional4,
    this.optional5,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
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
  final String? customer;

  /// Additional optional parameters that will be sent back to your backend.
  ///
  /// These can be anything you need, like API keys for authenticating Ozow's response.
  final String? optional1;
  final String? optional2;
  final String? optional3;
  final String? optional4;
  final String? optional5;

  ///Because this package uses a WebView, you can listen to the WebView events
  ///using the following callbacks.
  final void Function(String)? onPageStarted;
  final void Function(String)? onPageFinished;
  final void Function(int)? onProgress;
  final void Function(WebResourceError)? onWebResourceError;

  @override
  State<FlutterOzow> createState() => _FlutterOzowState();
}

class _FlutterOzowState extends State<FlutterOzow> {
  /// The controller for the WebView.
  late final WebViewController controller;

  /// Constructs the URI and request body.
  ///
  /// This prepares the data needed for making the POST request.
  ({Uri uri, Uint8List body}) getContents() {
    //after hosting th php file on your server, replace the baseUrl with the url to the php file
    //the amount and transactionId are only passed through the
    //url query strings to show the user the amount and transactionId on the payment page
    final String baseUrl =
        'https://flutter-ozow.azurewebsites.net/?amount=${widget.amount.toStringAsFixed(2)}&transactionId=${widget.transactionId}';

    // Prepare the body of the POST request.
    final body = {
      'transactionId': widget.transactionId.toString(),
      'siteCode': widget.siteCode,
      'privateKey': widget.privateKey,
      'bankRef': widget.bankRef,
      'amount': widget.amount.toStringAsFixed(2),
      'isTest': widget.isTest.toString(),
      'notifyUrl': widget.notifyUrl,
      'successUrl': widget.successUrl,
      'errorUrl': widget.errorUrl,
      'cancelUrl': widget.cancelUrl,
      'customer': widget.customer,
      'optional1': widget.optional1,
      'optional2': widget.optional2,
      'optional3': widget.optional3,
      'optional4': widget.optional4,
      'optional5': widget.optional5,
    };

    // Convert the body to a byte list.
    final bodyList = Uint8List.fromList(utf8.encode(json.encode(body)));
    // Parse the URL to a URI.
    final uri = Uri.parse(baseUrl);

    return (uri: uri, body: bodyList);
  }

  @override
  void initState() {
    super.initState();

    final uri = getContents().uri;
    final body = getContents().body;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: widget.onProgress ??
              (int progress) {
                if (kDebugMode) {
                  print(
                      'Flutter_ozow: WebView is loading (progress : $progress%)');
                }
              },
          onPageStarted: widget.onPageStarted ??
              (String url) {
                if (kDebugMode) {
                  print('Flutter_ozow: Page started loading: $url');
                }
              },
          onPageFinished: widget.onPageFinished ??
              (String url) {
                if (kDebugMode) {
                  print('Flutter_ozow: Page finished loading: $url');
                }
              },
          onWebResourceError: widget.onWebResourceError ??
              (WebResourceError error) {
                if (kDebugMode) {
                  print(
                      'Flutter_ozow: Error loading page: ${error.description}');
                }
              },
        ),
      )
      ..loadRequest(
        uri,
        method: LoadRequestMethod.post,
        body: body,
      );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: controller,
    );
  }
}
