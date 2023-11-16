import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ozow/src/data/models/ozow_link_model.dart';
import 'package:flutter_ozow/src/data/models/ozow_transaction_model.dart';

abstract class IOzowDataSource {
  /// Generates a payment link for the given [payment] map.
  Future<String?> generateLink({
    required Map<String, dynamic> payment,
    required String apiKey,
  });

  /// Gets the transaction details for the given [transactionId].
  ///
  /// This is to ensure that the transaction is valid and that the status
  Future<OzowTransactionModel?> getOzowTransaction({
    required String transactionId,
    required String siteCode,
    required String apiKey,
    required bool isTest,
  });
}

class OzowApi implements IOzowDataSource {
  @override
  Future<String?> generateLink({
    required Map<String, dynamic> payment,
    required String apiKey,
  }) async {
    try {
      final dio = Dio();

      ///set the headers
      dio.options.headers['ApiKey'] = apiKey;
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';

      final json = jsonEncode(payment);

      final res = await dio.post(
        'https://api.ozow.com/postpaymentrequest',
        data: json,
      );

      ///decode the response
      final link = OzowLinkModel.fromJson(res.data);

      return link.url;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  @override
  Future<OzowTransactionModel?> getOzowTransaction({
    required String transactionId,
    required String siteCode,
    required String apiKey,
    required bool isTest,
  }) async {
    try {
      final dio = Dio();
      const baseUrl = 'https://api.ozow.com/GetTransactionByReference';
      final url =
          '$baseUrl?siteCode=$siteCode&transactionReference=$transactionId&IsTest=$isTest';

      dio.options.headers['ApiKey'] = apiKey;

      final res = await dio.get(url);

      final data = (res.data as List).first;

      return OzowTransactionModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(
          'flutter_application_3_dart_native: Error getting transaction: $e',
        );
      }
      return null;
    }
  }
}
