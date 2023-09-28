

import 'package:flutter_ozow/src/models/status.dart';

class OzowTransaction {
  OzowTransaction({
    required this.transactionId,
    required this.transactionReference,
    required this.currencyCode,
    required this.amount,
    required this.status,
  });

  factory OzowTransaction.fromJson(Map<String, dynamic> json) {
    return OzowTransaction(
      transactionId: json['transactionId']?.toString(),
      transactionReference: json['transactionReference']?.toString(),
      currencyCode: json['currencyCode']?.toString(),
      amount: double.tryParse(json['amount'].toString()),
      status: ozowStatusFromStr(json['status']?.toString()),
    );
  }
  final String? transactionId;
  final String? transactionReference;
  final String? currencyCode;
  final double? amount;
  final OzowStatus status;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['transactionId'] = transactionId;
    data['transactionReference'] = transactionReference;
    data['currencyCode'] = currencyCode;
    data['amount'] = amount;
    data['status'] = status;
    return data;
  }
}
