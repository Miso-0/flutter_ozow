import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ozow/src/data/providers/ozow_data_provider.dart';
import 'package:flutter_ozow/src/data/models/ozow_payment.dart';
import 'package:flutter_ozow/src/data/models/ozow_status.dart';
import 'package:flutter_ozow/src/data/models/ozow_transaction.dart';

class OzowRepository {
  final OzowDataProvider _dataProvider;
  final OzowPayment _payment;

  OzowRepository({
    required OzowDataProvider dataProvider,
    required OzowPayment payment,
  })  : _dataProvider = dataProvider,
        _payment = payment;

  /// Generates the payment link.
  ///
  Future<Either<OzowStatus, String>> generateLink() async {
    if (kDebugMode) {
      print('map: ${_paymentMap()}');
    }

    final link = await _dataProvider.generatePaymentLink(
      payment: _paymentMap(),
      apiKey: _payment.apiKey,
    );
    return link.fold((l) {
      if (kDebugMode) {
        print(l.toString());
      }
      return const Left(OzowStatus.error);
    }, (r) {
      if (r == null) {
        if (kDebugMode) {
          print('flutter_ozow -> repo: Error generating link {link is null}');
        }
        return const Left(OzowStatus.error);
      }
      return Right(r);
    });
  }

  /// Verifies the payment status.
  ///
  /// This is to ensure that the payment was successful. and Ozow is aware of the transaction.
  ///
  /// Returns the status of the payment and the transaction details.
  Future<Either<OzowStatus, OzowTransaction>> verifyPayment(
    String status,
  ) async {
    //This is the status that is returned by the notification
    final unverifiedStatus = ozowStatusFromStr(status);
    if (unverifiedStatus != OzowStatus.complete) {
      return Left(unverifiedStatus);
    }

    ///we only need to verify the status if it is complete
    ///This is to ensure that ozow is aware of this transaction
    final transaction = await _dataProvider.fetchTransaction(
      transactionId: _payment.transactionId.toString(),
      siteCode: _payment.siteCode,
      apiKey: _payment.apiKey,
      isTest: _payment.isTest,
    );

    ///if the transaction is null, it means that the transaction
    ///does not exist on Ozow or there was an error getting the transaction
    ///
    if (transaction == null) {
      return const Left(OzowStatus.error);
    }

    ///return the actual status of the transaction
    ///from Ozow
    return Right(transaction);
  }

  /// Generates the hash for the POST request.
  String _generateHash() {
    _payment.successUrl ??= _payment.notifyUrl;
    _payment.cancelUrl ??= _payment.notifyUrl;
    _payment.errorUrl ??= _payment.notifyUrl;
    const countryCode = 'ZA';
    const currencyCode = 'ZAR';

    var hashStr = '${_payment.siteCode}$countryCode$currencyCode'
        '${_payment.amount.toStringAsFixed(2)}${_payment.transactionId}${_payment.bankRef}';

    // Add optional fields if they are not null
    var optionalFields = [
      _payment.optional1,
      _payment.optional2,
      _payment.optional3,
      _payment.optional4,
      _payment.optional5
    ];
    for (var optionalField in optionalFields) {
      if (optionalField != null) {
        hashStr += optionalField;
      }
    }

    // Add URL fields if they are not null
    var urlFields = [
      _payment.cancelUrl,
      _payment.errorUrl,
      _payment.successUrl,
      _payment.notifyUrl
    ];

    for (var urlField in urlFields) {
      if (urlField != null) {
        hashStr += urlField;
      }
    }

    // Add isTest and privateKey at the end
    hashStr += '${_payment.isTest}${_payment.privateKey}';

    // Convert the above concatenated string to lowercase
    hashStr = hashStr.toLowerCase();

    // Generate a SHA512 hash of the lowercase concatenated string
    var bytes = utf8.encode(hashStr);

    // ignore: unused_local_variable
    var hash = sha512.convert(bytes);

    return hash.toString();
  }

  ///creates the body for the POST request
  Map<String, dynamic> _paymentMap() {
    ///The notification sometimes does not come through.
    ///if the successUrl, cancelUrl and errorUrl are not set,
    ///So we set them to the notifyUrl since receiving the notification is more important.
    _payment.successUrl ??= _payment.notifyUrl;
    _payment.cancelUrl ??= _payment.notifyUrl;
    _payment.errorUrl ??= _payment.notifyUrl;
    // Prepare the body of the POST request.
    final body = {
      'transactionReference': _payment.transactionId.toString(),
      'siteCode': _payment.siteCode,
      'countryCode': 'ZA',
      'currencyCode': 'ZAR',
      'amount': _payment.amount.toStringAsFixed(2),
      'bankReference': _payment.bankRef,
      'isTest': _payment.isTest,
      'cancelUrl': _payment.cancelUrl,
      'errorUrl': _payment.errorUrl,
      'successUrl': _payment.successUrl,
      'notifyUrl': _payment.notifyUrl,
      'hashCheck': _generateHash()
    };

    // Add optional fields if they are not null
    var optionalFields = [
      _payment.optional1,
      _payment.optional2,
      _payment.optional3,
      _payment.optional4,
      _payment.optional5
    ];
    for (int i = 0; i < optionalFields.length; i++) {
      if (optionalFields[i] != null) {
        int count = i + 1;
        body['optional$count'] = optionalFields[i];
      }
    }

    return body;
  }
}
