// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// ignore_for_file: unused_element
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/domain/link_response.dart';
import 'package:flutter_ozow/src/domain/transaction.dart';
import 'package:flutter_ozow/src/domain/status.dart';
import 'package:flutter_ozow/src/presentation/flutter_ozow.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterOzowController {
  final FlutterOzow widget;
  final specialCharacters = ['&', '=', ';', ',', '?', '@', '+', '#', '%'];
  final void Function(int progress) onProgress;
  final void Function(UrlChange change) onUrlChange;

  ///s
  final void Function(String errorMessage, WebResourceErrorType? errorType)
      onError;
  WebViewController? _controller;

  FlutterOzowController(
    this.widget, {
    required this.onProgress,
    required this.onUrlChange,
    required this.onError,
  });

  WebViewController? get controller => _controller;

  /// Initializes the controller.
  Future<void> initialize() async {
    try {
      ///generate the link
      final link = await _generateLink();

      print(link);

      if (link == null) {
        onError('flutter_ozow: Error generating link', null);
        return;
      }

      ///initialize the controller
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) => onProgress(progress),
            onUrlChange: (UrlChange change) => onUrlChange(change),
            onPageStarted: (String url) {
              if (kDebugMode) {
                print(
                    'flutter_application_3_dart_native: Page started loading');
              }
            },
            onPageFinished: (String url) {
              if (kDebugMode) {
                print(
                    'flutter_application_3_dart_native: Page finished loading');
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (kDebugMode) {
                print(
                    'flutter_application_3_dart_native: Error loading page: ${error.description}');
              }
              onError(error.description, error.errorType);
            },
          ),
        )
        ..loadRequest(
          Uri.parse(link),
          method: LoadRequestMethod.post,
          body: _generateContents2(),
        );
    } catch (e) {
      onError('flutter_ozow: Error initializing controller', null);
      return;
    }
  }

  Future<({OzowStatus status, OzowTransaction? transaction})> decodeStatus(
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

  ///The notification sometimes does not come through.
  ///if the successUrl, cancelUrl and errorUrl are not set,
  ///So we set them to the notifyUrl since receiving the notification is more important.
  void _setDefaultUrls() {
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;
  }

  /// Gets the transaction from Ozow.
  ///
  /// This is to ensure that the transaction is valid and that the status
  Future<OzowTransaction?> _getOzowTransaction() async {
    try {
      final dio = Dio();
      const baseUrl = 'https://api.ozow.com/GetTransactionByReference';
      final url =
          '$baseUrl?siteCode=${widget.siteCode}&transactionReference=${widget.transactionId}&IsTest=${widget.isTest}';

      dio.options.headers['ApiKey'] = widget.apiKey;

      final res = await dio.get(url);

      final data = (res.data as List).first;

      return OzowTransaction.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(
            'flutter_application_3_dart_native: Error getting transaction: $e');
      }
      return null;
    }
  }

  /// Constructs the URI and request body.
  ///
  /// This prepares the data needed for making the POST request.
  Uri _uri() {
    _setDefaultUrls();
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

  /// Checks if the variables contain any invalid characters.
  ///
  /// This may interfere with query parameters in the URL.
  bool _isValidVariables() {
    List<String?> variables = [
      widget.transactionId.toString(),
      widget.siteCode,
      widget.bankRef,
      widget.apiKey,
      widget.amount.toString(),
      widget.privateKey,
      widget.notifyUrl,
      widget.successUrl,
      widget.errorUrl,
      widget.cancelUrl,
      widget.optional1,
      widget.optional2,
      widget.optional3,
      widget.optional4,
      widget.optional5
    ];

    for (String? variable in variables) {
      if (variable == null) continue;
      for (String char in specialCharacters) {
        if (variable.contains(char)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Generates the hash for the POST request.
  String _generateHash() {
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;

    const countryCode = 'ZA';
    const currencyCode = 'ZAR';

    var hashStr =
        '${widget.siteCode}$countryCode$currencyCode${widget.amount.toStringAsFixed(2)}${widget.transactionId}${widget.bankRef}';

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
      widget.cancelUrl,
      widget.errorUrl,
      widget.successUrl,
      widget.notifyUrl
    ];

    for (var urlField in urlFields) {
      if (urlField != null) {
        hashStr += urlField;
      }
    }

    // Add isTest and privateKey at the end
    hashStr += '${widget.isTest}${widget.privateKey}';

    // Convert the above concatenated string to lowercase
    hashStr = hashStr.toLowerCase();

    // Generate a SHA512 hash of the lowercase concatenated string
    var bytes = utf8.encode(hashStr);

    // ignore: unused_local_variable
    var hash = sha512.convert(bytes);

    return hash.toString();
  }

  ///creates the body for the POST request
  Map<String, dynamic> _body() {
    ///The notification sometimes does not come through.
    ///if the successUrl, cancelUrl and errorUrl are not set,
    ///So we set them to the notifyUrl since receiving the notification is more important.
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;
    // Prepare the body of the POST request.
    final body = {
      'transactionReference': widget.transactionId.toString(),
      'siteCode': widget.siteCode,
      'countryCode': 'ZA',
      'currencyCode': 'ZAR',
      'amount': widget.amount.toStringAsFixed(2),
      'bankReference': widget.bankRef,
      'isTest': widget.isTest,
      'cancelUrl': widget.cancelUrl,
      'errorUrl': widget.errorUrl,
      'successUrl': widget.successUrl,
      'notifyUrl': widget.notifyUrl,
      'hashCheck': _generateHash()
    };

    // Add optional fields if they are not null
    var optionalFields = [
      widget.optional1,
      widget.optional2,
      widget.optional3,
      widget.optional4,
      widget.optional5
    ];
    for (int i = 0; i < optionalFields.length; i++) {
      if (optionalFields[i] != null) {
        int count = i + 1;
        body['optional$count'] = optionalFields[i];
      }
    }

    return body;
  }

  /// Generates the link for the POST request.
  ///
  /// This is the link that the user will be redirected to.
  Future<String?> _generateLink() async {
    try {
      final dio = Dio();

      ///set the headers
      dio.options.headers['ApiKey'] = widget.apiKey;
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';

      final json = jsonEncode(_body());

      final res = await dio.post(
        'https://api.ozow.com/postpaymentrequest',
        data: json,
      );

      ///decode the response
      final link = OzowLinkResponse.fromJson(res.data);

      return link.url;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  /// Constructs the URI and request body.
  ///
  /// This prepares the data needed for making the POST request.
  Uint8List _generateContents2() {
    ///The notification sometimes does not come through.
    ///if the successUrl, cancelUrl and errorUrl are not set,
    ///So we set them to the notifyUrl since receiving the notification is more important.
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;

    // Prepare the body of the POST request.
    final body = {
      'TransactionReference': widget.transactionId.toString(),
      'SiteCode': widget.siteCode,
      'CountryCode': 'ZA',
      'CurrencyCode': 'ZAR',
      'Amount': widget.amount.toStringAsFixed(2),
      'BankReference': widget.bankRef,
      'isTest': widget.isTest.toString(),
      'CancelUrl': widget.cancelUrl,
      'ErrorUrl': widget.errorUrl,
      'SuccessUrl': widget.successUrl,
      'NotifyUrl': widget.notifyUrl,
      'Optional1': widget.optional1,
      'Optional2': widget.optional2,
      'Optional3': widget.optional3,
      'Optional4': widget.optional4,
      'Optional5': widget.optional5,
      'IsTest': widget.isTest,
      'HashCheck': _generateHash()
    };

    // Convert the body to a byte list.
    final bodyList = Uint8List.fromList(utf8.encode(json.encode(body)));

    return bodyList;
  }

  /// Constructs the URI and request body.
  ///
  /// This prepares the data needed for making the POST request.
  ({Uri uri, Uint8List body}) _generateContents() {
    ///The notification sometimes does not come through.
    ///if the successUrl, cancelUrl and errorUrl are not set,
    ///So we set them to the notifyUrl since receiving the notification is more important.
    widget.successUrl ??= widget.notifyUrl;
    widget.cancelUrl ??= widget.notifyUrl;
    widget.errorUrl ??= widget.notifyUrl;

    //after hosting th php file on your server, replace the baseUrl with the url to the php file
    //the amount and transactionId are only passed through the
    //url query strings to show the user the amount and transactionId on the payment page
    const url = 'https://flutter-ozow.web.app';
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
}
