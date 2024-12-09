class HttpExcepption implements Exception {
  String message;

  HttpExcepption(this.message);

  @override
  String toString() {
    return message;
  }
}
