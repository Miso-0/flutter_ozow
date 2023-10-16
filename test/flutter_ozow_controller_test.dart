import 'package:dio/dio.dart';
import 'package:flutter_ozow/src/controllers/flutter_ozow_controller.dart';
import 'package:flutter_ozow/src/presentation/flutter_ozow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'flutter_ozow_controller_test.mocks.dart';

@GenerateMocks([FlutterOzow, WebViewController, Dio])
void main() {
  group('FlutterOzowController', () {
    final mockFlutterOzow = MockFlutterOzow();
    // ignore: unused_local_variable
    final mockWebViewController = MockWebViewController();
    final mockDio = MockDio();

    late FlutterOzowController controller;

    setUp(() {
      // Initialize the controller
      controller = FlutterOzowController(
        mockFlutterOzow,
        onProgress: (_) {},
        onUrlChange: (_) {},
        onError: (_, __) {},
      );
    });

    test('initialize should handle link generation successfully', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async =>
          Response(
              data: {'url': 'test_url'},
              requestOptions: RequestOptions(path: '')));

      await controller.initialize();

      //asset that the url is set
    });

    test('initialize should handle link generation error', () async {
      when(mockDio.post(any, data: anyNamed('data')))
          .thenThrow(Exception('Failed to generate link'));

      await controller.initialize();
    });
  });
}
