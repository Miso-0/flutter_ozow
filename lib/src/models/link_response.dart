// Copyright 2023 UnderFlow SA
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class OzowLinkResponse {
  final String? id;
  final String? url;
  final String? message;

  OzowLinkResponse({
    required this.id,
    required this.url,
    required this.message,
  });

  factory OzowLinkResponse.fromJson(Map<String, dynamic> json) {
    return OzowLinkResponse(
      id: json['paymentRequestId'] as String?,
      url: json['url'] as String?,
      message: json['errorMessage'] as String?,
    );
  }
}
