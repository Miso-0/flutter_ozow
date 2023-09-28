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
                image: AssetImage(
                  'assets/tt.png',
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
                image: AssetImage(
                  'assets/loading.gif',
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
