// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_ozow/src/domain/status.dart';

class OzowTransaction {
  final String? transactionId;
  final String? transactionReference;
  final String? currencyCode;
  final double? amount;
  final OzowStatus verifiedStatus;

  OzowTransaction({
    required this.transactionId,
    required this.transactionReference,
    required this.currencyCode,
    required this.amount,
    required this.verifiedStatus,
  });

  factory OzowTransaction.fromJson(Map<String, dynamic> json) {
    return OzowTransaction(
      transactionId: json['transactionId'] as String?,
      transactionReference: json['transactionReference'] as String?,
      currencyCode: json['currencyCode'] as String?,
      amount: json['amount'] as double?,
      verifiedStatus: ozowStatusFromStr(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'transactionReference': transactionReference,
      'currencyCode': currencyCode,
      'amount': amount,
      'status': verifiedStatus.toString(),
    };
  }
}
