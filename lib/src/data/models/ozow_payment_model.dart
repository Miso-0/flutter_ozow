class OzowPaymentModel {
  String transactionReference;
  String siteCode;
  String countryCode;
  String currencyCode;
  String amount;
  String bankReference;
  bool isTest;
  String cancelUrl;
  String errorUrl;
  String successUrl;
  String notifyUrl;
  String hashCheck;

  OzowPaymentModel({
    required this.transactionReference,
    required this.siteCode,
    required this.countryCode,
    required this.currencyCode,
    required this.amount,
    required this.bankReference,
    required this.isTest,
    required this.cancelUrl,
    required this.errorUrl,
    required this.successUrl,
    required this.notifyUrl,
    required this.hashCheck,
  });

  factory OzowPaymentModel.fromJson(Map<String, dynamic> json) {
    return OzowPaymentModel(
      transactionReference: json['transactionReference'],
      siteCode: json['siteCode'],
      countryCode: json['countryCode'],
      currencyCode: json['currencyCode'],
      amount: json['amount'],
      bankReference: json['bankReference'],
      isTest: json['isTest'],
      cancelUrl: json['cancelUrl'],
      errorUrl: json['errorUrl'],
      successUrl: json['successUrl'],
      notifyUrl: json['notifyUrl'],
      hashCheck: json['hashCheck'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionReference': transactionReference,
      'siteCode': siteCode,
      'countryCode': countryCode,
      'currencyCode': currencyCode,
      'amount': amount,
      'bankReference': bankReference,
      'isTest': isTest,
      'cancelUrl': cancelUrl,
      'errorUrl': errorUrl,
      'successUrl': successUrl,
      'notifyUrl': notifyUrl,
      'hashCheck': hashCheck,
    };
  }
}
