// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class OzowLinkModel {
  final String? id;
  final String? url;
  final String? message;

  OzowLinkModel({
    required this.id,
    required this.url,
    required this.message,
  });

  factory OzowLinkModel.fromJson(Map<String, dynamic> json) {
    return OzowLinkModel(
      id: json['paymentRequestId'] as String?,
      url: json['url'] as String?,
      message: json['errorMessage'] as String?,
    );
  }

  //override = operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OzowLinkModel &&
        other.id == id &&
        other.url == url &&
        other.message == message;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ message.hashCode;
}
