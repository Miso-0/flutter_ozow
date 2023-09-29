import 'package:flutter/material.dart';
import 'package:flutter_ozow/src/models/status.dart';

/// The `FlutterOzowStatus` widget displays the status of the payment.
///
class FlutterOzowStatus extends StatelessWidget {
  const FlutterOzowStatus({super.key, required this.status});
  final OzowStatus status;

  /// The appropriate image, title and message for the status.
  /// based on the [status] provided.
  ({String image, String title, String message}) buildStatus() {
    switch (status) {
      case OzowStatus.complete:
        return (
          image: 'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/success.png?alt=media&token=97ffb95c-f555-4c70-88e6-0adaea8a24a0&_gl=1*116gkt3*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE5MTUuNjAuMC4w',
          title: 'Payment Successful',
          message: 'Great news! The payment was successful.',
        );
      case OzowStatus.cancelled:
        return (
          image: 'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/multiply.png?alt=media&token=19bd260a-9357-463c-93c6-da86e7993fc2&_gl=1*dad5co*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE4ODEuMTAuMC4w',
          title: 'Payment Cancelled',
          message: 'The payment was cancelled.',
        );

      case OzowStatus.abandoned:
        return (
          image: 'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/abandon.png?alt=media&token=36dbffff-e6d7-4877-9a72-9396613c0d71&_gl=1*1kdbxf*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE3ODMuNDcuMC4w',
          title: 'Payment Abandoned',
          message: 'The payment was abandoned.',
        );

      case OzowStatus.pendingInvestigation:
        return (
          image: 'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/expired.png?alt=media&token=5032b2c6-8a10-4590-8d68-58edbc1a43e4&_gl=1*bb45fa*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE4MzEuNjAuMC4w',
          title: 'Payment Pending',
          message: 'The payment is pending investigation.',
        );
      case OzowStatus.pending:
        return (
          image: 'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/expired.png?alt=media&token=5032b2c6-8a10-4590-8d68-58edbc1a43e4&_gl=1*bb45fa*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE4MzEuNjAuMC4w',
          title: 'Payment Pending',
          message: 'The status cannot be determined as yet.',
        );
      case OzowStatus.error:
        return (
          image: 'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/multiply.png?alt=media&token=19bd260a-9357-463c-93c6-da86e7993fc2&_gl=1*dad5co*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE4ODEuMTAuMC4w',
          title: 'Payment Error',
          message: 'An error occurred while processing the payment.',
        );
      default:
        return (
          image: 'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/multiply.png?alt=media&token=19bd260a-9357-463c-93c6-da86e7993fc2&_gl=1*dad5co*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE4ODEuMTAuMC4w',
          title: 'Payment Error',
          message: 'An error occurred while processing the payment.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = buildStatus();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            child: Image(
              image: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/tt.png?alt=media&token=63067346-8ab4-4c85-8e95-1708e59d64e4&_gl=1*420cgt*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE5NTguMTcuMC4w',
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: Image(
              image: NetworkImage(
                status.image,
              ),
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
}
