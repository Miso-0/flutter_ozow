// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ozow/flutter_ozow.dart';
import 'package:flutter_ozow/src/data/data_source/ozow_data_source.dart';
import 'package:flutter_ozow/src/domain/entities/ozow_payment.dart';
import 'package:flutter_ozow/src/domain/repository/ozow_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterOzowController {
  final void Function(int progress) onProgress;
  final void Function(UrlChange change) onUrlChange;
  final void Function(
    OzowStatus status,
    String errorMessage,
    WebResourceErrorType? errorType,
  ) onError;
  WebViewController? _controller;
  final OzowPayment payment;
  final OzowRepository _repository;

  FlutterOzowController({
    required this.payment,
    required this.onProgress,
    required this.onUrlChange,
    required this.onError,
  }) : _repository = OzowRepository(
          dataSource: OzowApi(),
          payment: payment,
        );

  WebViewController? get controller => _controller;
  OzowRepository get repository => _repository;

  /// Initializes the controller.
  Future<void> initialize() async {
    try {
      //generate the link
      final result = await _repository.generateLink();

      ///fold the result
      result.fold((status) {
        onError(
          status,
          'flutter_ozow: Error generating link',
          null,
        );
        return;
      }, (link) {
        return _controller = WebViewController()
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
                onError(
                  OzowStatus.error,
                  error.description,
                  error.errorType,
                );
              },
            ),
          )
          ..loadRequest(
            Uri.parse(link),
            method: LoadRequestMethod.post,
          );
      });

      ///initialize the controller
    } catch (e) {
      onError(
        OzowStatus.error,
        'flutter_ozow: Error initializing controller',
        null,
      );
      return;
    }
  }
}
