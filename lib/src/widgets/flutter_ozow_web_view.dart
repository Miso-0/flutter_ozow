// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// ignore_for_file: must_be_immutable, unused_element

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterOzowWebView extends StatelessWidget {
  const FlutterOzowWebView({
    super.key,
    required this.controller,
  });

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
