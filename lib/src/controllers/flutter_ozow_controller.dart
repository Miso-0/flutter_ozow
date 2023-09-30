// ignore_for_file: unused_element

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/models/transaction.dart';
import 'package:flutter_ozow/src/models/status.dart';
import 'package:flutter_ozow/src/widgets/flutter_ozow.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterOzowController {
  final FlutterOzow widget;
  final specialCharacters = ['&', '=', ';', ',', '?', '@', '+', '#', '%'];
  final void Function(int progress) onProgress;
  final void Function(UrlChange change) onUrlChange;
  late final WebViewController _controller;

  FlutterOzowController(
    this.widget, {
    required this.onProgress,
    required this.onUrlChange,
  }) {
    _controller = _init();
  }

  WebViewController get controller => _controller;

  /// Initializes the controller.
  WebViewController _init() {
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    /// Check if the variables contain any invalid characters.
    if (_isValidVariables()) {
      ///'&', '=', ';', ',', '?', '@', '+', '#', '%'
      throw Exception(
          'Flutter_ozow: Invalid characters in variables, your variables \nshould not contain any of the following characters: & = ; , ? @ + # %');
    }
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => onProgress(progress),
          onUrlChange: (UrlChange change) => onUrlChange(change),
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
      ..loadRequest(_uri());
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
        print('Flutter_ozow: Error getting transaction: $e');
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

    return hash.toString();
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
