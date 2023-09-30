// Copyright 2023 Miso Menze
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
// import 'dart:convert';
// ignore_for_file: must_be_immutable, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/controllers/flutter_ozow_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterOzowWebView extends StatelessWidget {
  const FlutterOzowWebView({
    super.key,
    required this.ozowController,
  });

  final FlutterOzowController ozowController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WebViewWidget(
        controller: ozowController.controller,
      ),
    );
  }
}
