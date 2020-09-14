class MessageException implements Exception {
  //basic message exception
  //I used this since flutter team don't suggest using built-in Exception
  final String message;
  MessageException(this.message);

  @override
  String toString() {
    return message;
  }
}
