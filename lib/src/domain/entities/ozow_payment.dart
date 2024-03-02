class OzowPayment {
  final Object transactionId;
  final String siteCode;
  final String privateKey;
  final String apiKey;
  final String bankRef;
  final double amount;
  final bool isTest;
  final String? optional1;
  final String? optional2;
  final String? optional3;
  final String? optional4;
  final String? optional5;
  final String notifyUrl;
  final String selectedBank;
  String? successUrl;
  String? cancelUrl;
  String? errorUrl;

  OzowPayment({
    required this.transactionId,
    required this.siteCode,
    required this.privateKey,
    required this.apiKey,
    required this.bankRef,
    required this.amount,
    required this.isTest,
    required this.notifyUrl,
    required this.selectedBank,
    this.successUrl,
    this.cancelUrl,
    this.errorUrl,
    this.optional1,
    this.optional2,
    this.optional3,
    this.optional4,
    this.optional5,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'transactionId': transactionId,
  //     'siteCode': siteCode,
  //     'privateKey': privateKey,
  //     'apiKey': apiKey,
  //     'bankRef': bankRef,
  //     'amount': amount,
  //     'isTest': isTest,
  //     'notifyUrl': notifyUrl,
  //     'successUrl': successUrl,
  //     'cancelUrl': cancelUrl,
  //     'errorUrl': errorUrl,
  //     'optional1': optional1,
  //     'optional2': optional2,
  //     'optional3': optional3,
  //     'optional4': optional4,
  //     'optional5': optional5,
  //   };
  // }

  ///Override operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OzowPayment &&
        runtimeType == other.runtimeType &&
        transactionId == other.transactionId &&
        siteCode == other.siteCode &&
        privateKey == other.privateKey &&
        apiKey == other.apiKey &&
        bankRef == other.bankRef &&
        amount == other.amount &&
        isTest == other.isTest &&
        selectedBank == other.selectedBank &&
        notifyUrl == other.notifyUrl &&
        successUrl == other.successUrl &&
        cancelUrl == other.cancelUrl &&
        errorUrl == other.errorUrl &&
        optional1 == other.optional1 &&
        optional2 == other.optional2 &&
        optional3 == other.optional3 &&
        optional4 == other.optional4 &&
        optional5 == other.optional5;
  }

  @override
  int get hashCode =>
      transactionId.hashCode ^
      siteCode.hashCode ^
      privateKey.hashCode ^
      apiKey.hashCode ^
      bankRef.hashCode ^
      amount.hashCode ^
      isTest.hashCode ^
      selectedBank.hashCode ^
      notifyUrl.hashCode ^
      successUrl.hashCode ^
      cancelUrl.hashCode ^
      errorUrl.hashCode ^
      optional1.hashCode ^
      optional2.hashCode ^
      optional3.hashCode ^
      optional4.hashCode ^
      optional5.hashCode;
}
