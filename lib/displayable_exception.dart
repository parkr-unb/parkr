class DisplayableException implements Exception {
  String cause;
  DisplayableException(this.cause);

  @override
  String toString() {
    return cause;
  }
}
