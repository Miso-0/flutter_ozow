import 'package:flutter_ozow/flutter_ozow.dart';

class OzowTransaction {
  final String transactionId;
  final String transactionReference;
  final String currencyCode;
  final double amount;
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
      transactionId: json['transactionId'],
      transactionReference: json['transactionReference'],
      currencyCode: json['currencyCode'],
      amount: json['amount'],
      verifiedStatus: ozowStatusFromStr(json['status']),
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
