import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ozow/src/data/models/ozow_link.dart';
import 'package:flutter_ozow/src/data/models/ozow_transaction.dart';
import 'package:flutter_ozow/src/exception.dart';

abstract class OzowDataProvider {
  /// Generates a payment link for the given [payment] map.
  Future<Either<OzowException, String?>> generatePaymentLink(
      {required Map<String, dynamic> payment, required String apiKey});

  /// Gets the transaction details for the given [transactionId].
  ///
  /// This is to ensure that the transaction is valid and that the status
  Future<OzowTransaction?> fetchTransaction({
    required String transactionId,
    required String siteCode,
    required String apiKey,
    required bool isTest,
  });
}

class OzowDataProviderImpl implements OzowDataProvider {
  final Dio _dio;
  OzowDataProviderImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<Either<OzowException, String?>> generatePaymentLink({
    required Map<String, dynamic> payment,
    required String apiKey,
  }) async {
    try {
      ///set the headers
      _dio.options.headers['ApiKey'] = apiKey;
      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';
      const url = 'https://api.ozow.com/postpaymentrequest';
      final data = jsonEncode(payment);
      final res = await _dio.post(url, data: data);

      ///decode the response
      final link = OzowLink.fromJson(res.data);
      return Right(link.url);
    } catch (e) {
      if (kDebugMode) {
        print('Flutter  -> repo $e');
      }
      return Left(OzowException(e.toString()));
    }
  }

  @override
  Future<OzowTransaction?> fetchTransaction({
    required String transactionId,
    required String siteCode,
    required String apiKey,
    required bool isTest,
  }) async {
    try {
      const baseUrl = 'https://api.ozow.com/GetTransactionByReference';
      final url = '$baseUrl?siteCode=$siteCode&transactionReference'
          '=$transactionId&IsTest=$isTest';
      _dio.options.headers['ApiKey'] = apiKey;
      final res = await _dio.get(url);
      final data = (res.data as List).first;
      return OzowTransaction.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(
          'Flutter ozow  -> dp: Error getting transaction: $e',
        );
      }
      return null;
    }
  }
}
