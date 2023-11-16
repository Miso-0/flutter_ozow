// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_ozow/flutter_ozow.dart';
import 'package:flutter_ozow/src/data/models/ozow_transaction_model.dart';

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

  factory OzowTransaction.fromModel(OzowTransactionModel model) {
    return OzowTransaction(
      transactionId: model.transactionId,
      transactionReference: model.transactionReference,
      currencyCode: model.currencyCode,
      amount: model.amount,
      verifiedStatus:ozowStatusFromStr(model.verifiedStatus),
    );
  }
}
