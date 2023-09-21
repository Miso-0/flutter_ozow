// import 'dart:convert';
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
    this.customName,
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
  final String? customName;

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

  String buildUrl() {
    // Initialize the Map for query parameters
    Map<String, String> queryParams = {};

    // Required parameters
    queryParams['transactionId'] = widget.transactionId.toString();
    queryParams['siteCode'] = widget.siteCode;
    queryParams['bankRef'] = widget.bankRef;
    queryParams['amount'] = widget.amount.toStringAsFixed(2);
    queryParams['privateKey'] = widget.privateKey;
    queryParams['isTest'] = widget.isTest.toString();

    // Optional parameters
    if (widget.notifyUrl != null) queryParams['notifyUrl'] = widget.notifyUrl!;
    if (widget.successUrl != null) {
      queryParams['successUrl'] = widget.successUrl!;
    }
    if (widget.errorUrl != null) queryParams['errorUrl'] = widget.errorUrl!;
    if (widget.cancelUrl != null) queryParams['cancelUrl'] = widget.cancelUrl!;
    if (widget.customName != null) {
      queryParams['customName'] = widget.customName!;
    }
    if (widget.optional1 != null) queryParams['optional1'] = widget.optional1!;
    if (widget.optional2 != null) queryParams['optional2'] = widget.optional2!;
    if (widget.optional3 != null) queryParams['optional3'] = widget.optional3!;
    if (widget.optional4 != null) queryParams['optional4'] = widget.optional4!;
    if (widget.optional5 != null) queryParams['optional5'] = widget.optional5!;

    // Convert the Map to query string
    String queryString = Uri(queryParameters: queryParams).query;

    // Build the final URL
    final baseUrl = 'https://flutter-ozow.azurewebsites.net/?$queryString';

    return baseUrl;
  }

  @override
  void initState() {
    super.initState();
    if (isValidVariables()) {
      final uri = Uri.parse(buildUrl());
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        // ..setNavigationDelegate(
        //   NavigationDelegate(
        //     onProgress: widget.onProgress ??
        //         (int progress) {
        //           if (kDebugMode) {
        //             print(
        //                 'Flutter_ozow: WebView is loading (progress : $progress%)');
        //           }
        //         },
        //     onPageStarted: widget.onPageStarted ??
        //         (String url) {
        //           if (kDebugMode) {
        //             print('Flutter_ozow: Page started loading: $url');
        //           }
        //         },
        //     onPageFinished: widget.onPageFinished ??
        //         (String url) {
        //           if (kDebugMode) {
        //             print('Flutter_ozow: Page finished loading: $url');
        //           }
        //         },
        //     onWebResourceError: widget.onWebResourceError ??
        //         (WebResourceError error) {
        //           if (kDebugMode) {
        //             print(
        //                 'Flutter_ozow: Error loading page: ${error.description}');
        //           }
        //         },
        //   ),

        // )
        ..loadRequest(
          uri,
        );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isValidVariables()) {
      return WebViewWidget(
        controller: controller,
      );
    } else {
      return const Center(
        child: Text(
          'Invalid variables, ensure that all your variables do not '
          'contain the characters \'&\' or \'=\'.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  // This function checks if the given variables contain invalid characters ('&' or '=')
  // and returns true if all variables are valid, otherwise returns false.
  bool isValidVariables() {
    if (widget.transactionId.toString().contains('&') ||
        widget.transactionId.toString().contains('=')) {
      return false;
    }
    if (widget.siteCode.contains('&') || widget.siteCode.contains('=')) {
      return false;
    }

    if (widget.bankRef.contains('&') || widget.bankRef.contains('=')) {
      return false;
    }

    if (widget.amount.toString().contains('&') ||
        widget.amount.toString().contains('=')) {
      return false;
    }

    if (widget.privateKey.contains('&') || widget.privateKey.contains('=')) {
      return false;
    }

    if (widget.notifyUrl != null) {
      if (widget.notifyUrl!.contains('&') || widget.notifyUrl!.contains('=')) {
        return false;
      }
    }

    if (widget.successUrl != null) {
      if (widget.successUrl!.contains('&') ||
          widget.successUrl!.contains('=')) {
        return false;
      }
    }

    if (widget.errorUrl != null) {
      if (widget.errorUrl!.contains('&') || widget.errorUrl!.contains('=')) {
        return false;
      }
    }

    if (widget.cancelUrl != null) {
      if (widget.cancelUrl!.contains('&') || widget.cancelUrl!.contains('=')) {
        return false;
      }
    }

    if (widget.customName != null) {
      if (widget.customName!.contains('&') ||
          widget.customName!.contains('=')) {
        return false;
      }
    }

    if (widget.optional1 != null) {
      if (widget.optional1!.contains('&') || widget.optional1!.contains('=')) {
        return false;
      }
    }

    if (widget.optional2 != null) {
      if (widget.optional2!.contains('&') || widget.optional2!.contains('=')) {
        return false;
      }
    }

    if (widget.optional3 != null) {
      if (widget.optional3!.contains('&') || widget.optional3!.contains('=')) {
        return false;
      }
    }

    if (widget.optional4 != null) {
      if (widget.optional4!.contains('&') || widget.optional4!.contains('=')) {
        return false;
      }
    }

    if (widget.optional5 != null) {
      if (widget.optional5!.contains('&') || widget.optional5!.contains('=')) {
        return false;
      }
    }

    return true;
  }
}
