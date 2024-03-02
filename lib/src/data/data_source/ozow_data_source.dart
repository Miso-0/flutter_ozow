import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ozow/src/data/models/ozow_link_model.dart';
import 'package:flutter_ozow/src/data/models/ozow_transaction_model.dart';
import 'package:flutter_ozow/src/exception.dart';

abstract class IOzowDataSource {
  /// Generates a payment link for the given [payment] map.
  Future<Either<OzowException, String?>> generateLink({
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

class OzowApiDataSource implements IOzowDataSource {
  final Dio _dio;
  OzowApiDataSource({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<Either<OzowException, String?>> generateLink({
    required Map<String, dynamic> payment,
    required String apiKey,
  }) async {
    try {
      ///set the headers
      _dio.options.headers['ApiKey'] = apiKey;
      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';

      final json = jsonEncode(payment);

      final res = await _dio.post(
        'https://api.ozow.com/postpaymentrequest',
        data: json,
      );

      print(res.data);
      print(res.statusCode);

      ///decode the response
      final link = OzowLinkModel.fromJson(res.data);

      return Right(link.url);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Left(OzowException(e.toString()));
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
      const baseUrl = 'https://api.ozow.com/GetTransactionByReference';
      final url =
          '$baseUrl?siteCode=$siteCode&transactionReference=$transactionId&IsTest=$isTest';

      _dio.options.headers['ApiKey'] = apiKey;

      final res = await _dio.get(url);

      final data = (res.data as List).first;

      return OzowTransactionModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(
          'Flutter ozow: Error getting transaction: $e',
        );
      }
      return null;
    }
  }
}
