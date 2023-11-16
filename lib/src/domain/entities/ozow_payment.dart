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
    this.successUrl,
    this.cancelUrl,
    this.errorUrl,
    this.optional1,
    this.optional2,
    this.optional3,
    this.optional4,
    this.optional5,
  });


  Map<String,dynamic> toMap(){
    return {
      'transactionId': transactionId,
      'siteCode': siteCode,
      'privateKey': privateKey,
      'apiKey': apiKey,
      'bankRef': bankRef,
      'amount': amount,
      'isTest': isTest,
      'notifyUrl': notifyUrl,
      'successUrl': successUrl,
      'cancelUrl': cancelUrl,
      'errorUrl': errorUrl,
      'optional1': optional1,
      'optional2': optional2,
      'optional3': optional3,
      'optional4': optional4,
      'optional5': optional5,
    };
  }
}
