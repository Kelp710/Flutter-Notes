// login exceptions
class UserNotFoundAuthException implements Exception {
  final String message;

  UserNotFoundAuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class WorongOasswordAuthException implements Exception {
  final String message;

  WorongOasswordAuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

// register exceptions

class WeakPasswordAuthException implements Exception {
  final String message;

  WeakPasswordAuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class EmailAlreadyInUseAuthException implements Exception {
  final String message;

  EmailAlreadyInUseAuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class InvalidEmailAuthException implements Exception {
  final String message;

  InvalidEmailAuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

// GENERIC EXCEPTION
class GenericAuthException implements Exception {
  final String message;

  GenericAuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class UserNotLoggedInAuthException implements Exception {
  final String message;

  UserNotLoggedInAuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
