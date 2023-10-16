import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_ozow/src/presentation/flutter_ozow.dart'; // import your library containing the FlutterOzow class

void main() {
  testWidgets('FlutterOzow widget builds successfully',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterOzow(
            transactionId: '123',
            siteCode: 'SC001',
            privateKey: 'PRIVATEKEY123',
            bankRef: 'BANKREF123',
            amount: 100.0,
            isTest: true,
            apiKey: 'APIKEY123',
            notifyUrl: 'https://your-notify-url.com',
          ),
        ),
      ),
    );
    // Verify if the WebViewWidget is present
    expect(find.byType(WebViewWidget), findsOneWidget);
  });
}
