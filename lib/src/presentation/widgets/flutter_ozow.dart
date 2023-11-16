// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/domain/entities/ozow_payment.dart';
import 'package:flutter_ozow/src/domain/entities/ozow_status.dart';
import 'package:flutter_ozow/src/domain/entities/ozow_transaction.dart';
import 'package:flutter_ozow/src/presentation/controllers/flutter_ozow_controller.dart';
import 'package:flutter_ozow/src/presentation/widgets/flutter_ozow_loading_indicator.dart';
import 'package:flutter_ozow/src/presentation/widgets/flutter_ozow_status.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'flutter_ozow_linear_loading_indicator.dart';
import 'flutter_ozow_web_view.dart';

/// The `FlutterOzow` widget integrates Ozow payment gateway through a WebView.
///
/// This widget utilizes [webview_flutter] to render a web page that assists
/// with completing payments via the Ozow payment gateway.
/// More information can be found at https://ozow.com.
// ignore: must_be_immutable
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
  State<FlutterOzow> createState() => _FlutterOzowState();
}

class _FlutterOzowState extends State<FlutterOzow> {
  ///
  late final FlutterOzowController ozowController;

  ///This is the status of the transaction
  ///
  OzowStatus? _status;

  ///This is to show the loading indicator widget
  bool _isLoading = false;

  ///to show the progress of the page loading
  int progress = 0;

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

    final payment = OzowPayment(
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
    );

    ///initialize the controller
    ozowController = FlutterOzowController(
      payment: payment,
      onProgress: (int progress) {
        setState(() {
          this.progress = progress;
        });
      },
      onUrlChange: (UrlChange change) => handleUrlChange(
        change,
      ),
      onError: (status, errorMessage, errorType) {
        if (widget.onError != null) {
          widget.onError!(errorMessage, errorType);
        }
      },
    );

    _init();
  }

  Future<void> _init() async {
    setLoading(true);
    await ozowController.initialize();
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display a progress indicator with custom color.
        FlutterOzowLinearLoadingIndicator(progress: progress),
        // Show the WebViewWidget when both '_status' is null and '_isLoading' is false.
        // This implies that there is no current status and loading is complete.
        if (!_isLoading && ozowController.controller != null && _status == null)
          FlutterOzowWebView(controller: ozowController.controller!)

        // Show a loading indicator when '_isLoading' is true.
        // This implies that some data or UI is being loaded.
        else if (_isLoading)
          const FlutterOzowLoadingIndicator()

        // Show FlutterOzowStatus when '_status' is not null.
        // This implies that there is a status to be displayed (e.g., error, success).
        else
          //if the onCompleteWidget is not null, call it
          //with the status of the transaction
          FlutterOzowStatus(status: _status!),
      ],
    );
  }

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
      final res = await ozowController.repository.verifyPayment(status);
      setLoading(false);

      res.fold((status) {
        if (widget.onError != null) {
          widget.onError!(
            'flutter_ozow: Error verifying payment',
            null,
          );
        }
        setStatus(status);
      }, (transaction) {
        ///update the status of the transaction
        ///to update the UI
        setStatus(
          transaction.verifiedStatus,
        );

        ///if the onComplete callback is not null, call it
        ///with the status of the transaction
        if (widget.onComplete != null) {
          widget.onComplete!(
            transaction,
            transaction.verifiedStatus,
          );
        }
      });
    }
  }
}
