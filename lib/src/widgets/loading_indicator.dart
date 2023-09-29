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
            const SizedBox(
              child: Image(
                image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/tt.png?alt=media&token=63067346-8ab4-4c85-8e95-1708e59d64e4&_gl=1*420cgt*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE5NTguMTcuMC4w',
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 80,
              width: 80,
              child: Image(
                image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/flutter-ozow.appspot.com/o/loading.gif?alt=media&token=bd429e48-0089-4c5d-9b21-f4b827f609bf&_gl=1*1y68yjm*_ga*MTg2MTI0OTAxMy4xNjUzOTAwNTU3*_ga_CW55HF8NVT*MTY5NTk1MTU1OC4zMC4xLjE2OTU5NTE2NTcuNDkuMC4w',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Text(
                'Hold on while we verify your payment',
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
