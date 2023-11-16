// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

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
}
