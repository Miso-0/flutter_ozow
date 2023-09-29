// Copyright 2023 Miso Menze
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
// import 'dart:convert';
// ignore_for_file: must_be_immutable, unused_element

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/models/status.dart';
import 'package:flutter_ozow/src/widgets/flutter_ozow_status.dart';
import 'package:flutter_ozow/src/widgets/loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/ozow_transaction.dart';

/// The `FlutterOzow` widget integrates Ozow payment gateway through a WebView.
///
/// This widget utilizes [webview_flutter] to render a web page that assists
/// with completing payments via the Ozow payment gateway.
/// More information can be found at https://ozow.com.
class FlutterOzow extends StatefulWidget {
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
    this.optional1,
    this.optional2,
    this.optional3,
    this.optional4,
    this.optional5,
    this.onComplete,
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
  final void Function(OzowTransaction?, OzowStatus)? onComplete;

  @override
  State<FlutterOzow> createState() => _FlutterOzowState();
}

class _FlutterOzowState extends State<FlutterOzow> {
  /// The controller for the WebView.
  late final WebViewController controller;

  ///This is the status of the transaction
  ///
  OzowStatus? _status;

  ///This is to show the loading indicator widget
  bool _isLoading = false;

  ///to show the progress of the page loading
  int progress = 0;

  /// Handles the URL change.
  /// Then updates the status of the transaction.
  /// If the onComplete callback is not null, it will be called.
  /// with the status of the transaction
  Future<void> handleUrlChange(UrlChange urlChange) async {
    if (urlChange.url != null) {
      final url = urlChange.url!;
      final uri = Uri.parse(url);
      final queryParams = uri.queryParameters;
      final status = queryParams['Status'];

      if (status == null) return;

      ///verify the status of the transaction
      setLoading(true);
      final res = await _decodeStatus(status);
      setLoading(false);

      ///update the status of the transaction
      ///to update the UI
      setStatus(res.status);

      ///if the onComplete callback is not null, call it
      ///with the status of the transaction
      if (widget.onComplete != null) {
        widget.onComplete!(res.transaction, res.status);
      }
    }
  }

  Future<({OzowStatus status, OzowTransaction? transaction})> _decodeStatus(
      String status) async {
    final incomingStatus = ozowStatusFromStr(status);
    if (incomingStatus != OzowStatus.complete) {
      return (status: incomingStatus, transaction: null);
    }

    ///we only need to verify the status if it is complete
    ///This is to ensure that ozow is aware of this transaction
    final transaction = await _getOzowTransaction();

    ///if the transaction is null, it means that the transaction
    ///does not exist on Ozow or there was an error getting the transaction
    ///
    if (transaction == null) {
      return (status: OzowStatus.error, transaction: null);
    }

    ///return the actual status of the transaction
    ///from Ozow
    return (status: transaction.verifiedStatus, transaction: transaction);
  }

  void setStatus(OzowStatus status) {
    setState(() {
      _status = status;
    });
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    /// Check if the variables contain any invalid characters.
    if (!isValidVariables()) {
      throw Exception(
        'Flutter_ozow: Invalid characters in variables, your variables should not contain & or =',
      );
    }

    /// Get the URI and body for the POST request.
    final uri = buildUri();

    // print(uri);
    // // final body = _getContents().body;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
            });
          },
          onUrlChange: (UrlChange change) => handleUrlChange(change),
          onPageStarted: (String url) {
            if (kDebugMode) {
              print('Flutter_ozow: Page started loading');
            }
          },
          onPageFinished: (String url) {
            if (kDebugMode) {
              print('Flutter_ozow: Page finished loading');
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (kDebugMode) {
              print('Flutter_ozow: Error loading page: ${error.description}');
            }
          },
        ),
      )
      ..loadRequest(uri);
    setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: Colors.transparent,
          color: const Color.fromRGBO(0, 222, 140, 1),
        ),
        if (_isLoading)
          const FlutterOzowLoadingIndicator()
        else if (_status == null && !_isLoading)
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          )
        else
          FlutterOzowStatus(
            status: _status!,
          ),
      ],
    );
  }

  ///Gets the transaction details from Ozow
  ///This helps us validate the existence of the transaction on Ozow
  ///
  Future<OzowTransaction?> _getOzowTransaction() async {
    try {
      final dio = Dio();
      const baseUrl = 'https://api.ozow.com/GetTransactionByReference';
      final url =
          '$baseUrl?siteCode=${widget.siteCode}&transactionReference=${widget.transactionId}&IsTest=${widget.isTest}';

      dio.options.headers['ApiKey'] = widget.apiKey;

      final res = await dio.get(url);

      // final res = await http.get(
      //   Uri.parse(url),
      //   headers: {
      //     'ApiKey': widget.apiKey,
      //     'content-type': 'application/json',
      //   },
      // );

      final json = (jsonDecode(res.data) as List).first;

      return OzowTransaction.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print('Flutter_ozow: Error getting transaction: $e');
      }
      return null;
    }
  }

  /// Constructs the URI and request body.
  ///
  /// This prepares the data needed for making the POST request.
  ({Uri uri, Uint8List body}) _getContents() {
    ///The notification sometimes does not come through.
    ///if the successUrl, cancelUrl and errorUrl are not set,
    ///So we set them to the notifyUrl since receiving the notification is more important.
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;

    //after hosting th php file on your server, replace the baseUrl with the url to the php file
    //the amount and transactionId are only passed through the
    //url query strings to show the user the amount and transactionId on the payment page
    const url = 'https://flutter-ozow.azurewebsites.net/';
    final String baseUrl =
        '$url?amount=${widget.amount.toStringAsFixed(2)}&transactionId=${widget.transactionId}';

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

  /// Constructs the URI and request body.
  ///
  /// This prepares the data needed for making the POST request.
  Uri buildUri() {
    ///The notification sometimes does not come through.
    ///if the successUrl, cancelUrl and errorUrl are not set,
    ///So we set them to the notifyUrl since receiving the notification is more important.
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;
    //the amount and transactionId are only passed through the
    //url query strings to show the user the amount and transactionId on the payment page
    const url = 'https://flutter-ozow.web.app';

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
      'optional1': widget.optional1,
      'optional2': widget.optional2,
      'optional3': widget.optional3,
      'optional4': widget.optional4,
      'optional5': widget.optional5,
    };

    // Create an initial URI object
    Uri uri = Uri.parse(url);

    // Replace existing query parameters with the new ones
    uri = uri.replace(
      queryParameters: body.map(
        (key, value) => MapEntry(
          key,
          value.toString(),
        ),
      ),
    );

    return uri;
  }

  void _generateHash() {
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;

    var hashStr = '${widget.siteCode}'
        'ZA'
        'ZAR'
        '${widget.amount}'
        '${widget.transactionId}'
        '${widget.bankRef}';

    // Add optional fields if they are not null
    var optionalFields = [
      widget.optional1,
      widget.optional2,
      widget.optional3,
      widget.optional4,
      widget.optional5
    ];
    for (var optionalField in optionalFields) {
      if (optionalField != null) {
        hashStr += optionalField;
      }
    }

    // Add URL fields if they are not null
    var urlFields = [
      widget.notifyUrl,
      widget.successUrl,
      widget.errorUrl,
      widget.cancelUrl
    ];

    for (var urlField in urlFields) {
      if (urlField != null) {
        hashStr += urlField;
      }
    }

    // Add isTest and privateKey at the end
    hashStr += '$widget.isTest' '$widget.privateKey';

    // Convert the above concatenated string to lowercase
    hashStr = hashStr.toLowerCase();

    // Generate a SHA512 hash of the lowercase concatenated string
    var bytes = utf8.encode(hashStr);
    // ignore: unused_local_variable
    var hash = sha512.convert(bytes);
  }

  /// Checks if the variables contain any invalid characters.
  ///
  /// This may interfere with query parameters in the URL.
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
    if (widget.apiKey.contains('&') || widget.apiKey.contains('=')) {
      return false;
    }
    if (widget.amount.toString().contains('&') ||
        widget.amount.toString().contains('=')) {
      return false;
    }

    if (widget.privateKey.contains('&') || widget.privateKey.contains('=')) {
      return false;
    }

    if (widget.notifyUrl.contains('&') || widget.notifyUrl.contains('=')) {
      return false;
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
