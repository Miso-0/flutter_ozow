import 'package:flutter_ozow/src/models/status.dart';

class OzowTransaction {
  final String? transactionId;
  final String? transactionReference;
  final String? currencyCode;
  final double? amount;
  final OzowStatus status;

  OzowTransaction({
    required this.transactionId,
    required this.transactionReference,
    required this.currencyCode,
    required this.amount,
    required this.status,
  });

  factory OzowTransaction.fromJson(Map<String, dynamic> json) {
    return OzowTransaction(
      transactionId: json['transactionId'] as String?,
      transactionReference: json['transactionReference'] as String?,
      currencyCode: json['currencyCode'] as String?,
      amount: json['amount'] as double?,
      status: ozowStatusFromStr(json['status'] as String?),
    );
  }
}
