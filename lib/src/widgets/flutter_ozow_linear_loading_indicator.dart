// Copyright 2023 Miso Menze
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
// import 'dart:convert';
// ignore_for_file: must_be_immutable, unused_element

import 'package:flutter/material.dart';

class FlutterOzowLinearLoadingIndicator extends StatelessWidget {
  const FlutterOzowLinearLoadingIndicator({
    super.key,
    required this.progress,
  });

  final int progress;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress / 100,
      backgroundColor: Colors.transparent,
      color: const Color.fromRGBO(0, 222, 140, 1),
    );
  }
}
