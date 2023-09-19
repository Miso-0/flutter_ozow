import 'package:flutter_ozow_example/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionNotifier extends Notifier<Transaction> {
  @override
  Transaction build() {
    return Transaction(id: '121212', status: TransactionStatus.pending);
  }

  void updateStatus() {
    if (state.status == TransactionStatus.processing) {
      state = state.copyWith(status: TransactionStatus.pending);
    } else {
      state = state.copyWith(status: TransactionStatus.processing);
    }
  }
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, Transaction>(() {
  return TransactionNotifier();
});
