// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class OzowTransactionModel {
  final String transactionId;
  final String transactionReference;
  final String currencyCode;
  final double amount;
  final String verifiedStatus;

  OzowTransactionModel({
    required this.transactionId,
    required this.transactionReference,
    required this.currencyCode,
    required this.amount,
    required this.verifiedStatus,
  });

  factory OzowTransactionModel.fromJson(Map<String, dynamic> json) {
    return OzowTransactionModel(
      transactionId: json['transactionId'],
      transactionReference: json['transactionReference'],
      currencyCode: json['currencyCode'],
      amount: json['amount'],
      verifiedStatus: json['status'],
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
