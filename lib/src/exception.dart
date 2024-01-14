class OzowException implements Exception {
  final String message;
  OzowException(this.message);

  @override
  String toString() {
    return message;
  }
}
