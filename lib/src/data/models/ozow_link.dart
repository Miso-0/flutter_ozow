class OzowLink {
  final String? id;
  final String? url;
  final String? message;

  OzowLink({
    required this.id,
    required this.url,
    required this.message,
  });

  factory OzowLink.fromJson(Map<String, dynamic> json) {
    return OzowLink(
      id: json['paymentRequestId'] as String?,
      url: json['url'] as String?,
      message: json['errorMessage'] as String?,
    );
  }
  //override = operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OzowLink &&
        other.id == id &&
        other.url == url &&
        other.message == message;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ message.hashCode;
}
