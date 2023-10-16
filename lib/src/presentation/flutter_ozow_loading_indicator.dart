// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// The `FlutterOzowLoadingIndicator` widget displays the status of the payment.
///
class FlutterOzowLoadingIndicator extends StatelessWidget {
  const FlutterOzowLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(249, 249, 249, 1),
      padding: const EdgeInsets.only(bottom: 50),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: Image.asset(
                "assets/backgroud.png",
                package: "flutter_ozow",
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset(
                "assets/loading_gif.gif",
                package: "flutter_ozow",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Text(
                "Hold on while we process your payment.",
                style: TextStyle(
                  color: Colors.blueGrey.shade500,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
