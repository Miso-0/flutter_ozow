// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/domain/ozow_status.dart';

/// The `FlutterOzowStatus` widget displays the status of the payment.
///
class FlutterOzowStatus extends StatelessWidget {
  const FlutterOzowStatus({super.key, required this.status});
  final OzowStatus status;

  @override
  Widget build(BuildContext context) {
    final status = buildStatus();
    return SingleChildScrollView(
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
            height: 25,
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
              status.image,
              package: "flutter_ozow",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            status.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
            child: Text(
              status.message,
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
    );
  }

  /// The appropriate image, title and message for the status.
  /// based on the [status] provided.
  ({String image, String title, String message}) buildStatus() {
    switch (status) {
      case OzowStatus.complete:
        return (
          image: "assets/success.png",
          title: "Payment Successful",
          message: "Great news! The payment was successful.",
        );
      case OzowStatus.cancelled:
        return (
          image: "assets/multiply.png",
          title: "Payment Cancelled",
          message: "The payment was cancelled.",
        );

      case OzowStatus.abandoned:
        return (
          image: "assets/abandon.png",
          title: "Payment Abandoned",
          message: "The payment was abandoned.",
        );

      case OzowStatus.pendingInvestigation:
        return (
          image: "assets/expired.png",
          title: "Payment Pending",
          message: "The payment is pending investigation.",
        );
      case OzowStatus.pending:
        return (
          image: "assets/expired.png",
          title: "Payment Pending",
          message: "The status cannot be determined as yet.",
        );
      case OzowStatus.error:
        return (
          image: "assets/multiply.png",
          title: "Payment Error",
          message: "An error occurred while processing the payment.",
        );
      default:
        return (
          image: "assets/multiply.png",
          title: "Payment Error",
          message: "An error occurred while processing the payment.",
        );
    }
  }
}
