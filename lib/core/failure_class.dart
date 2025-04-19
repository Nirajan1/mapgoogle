// failure.dart
abstract class Failure {
  String get message;
}

class LocationServiceFailure implements Failure {
  @override
  final String message;

  LocationServiceFailure(this.message);
}

class LocationPermissionFailure implements Failure {
  @override
  final String message;

  LocationPermissionFailure(this.message);
}

class LocationPermissionDeniedForeverFailure implements Failure {
  @override
  final String message;

  LocationPermissionDeniedForeverFailure(this.message);
}

class UnknownFailure implements Failure {
  @override
  final String message;

  UnknownFailure(this.message);
}
