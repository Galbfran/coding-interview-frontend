sealed class ApiFailure {
  const ApiFailure();
}

final class NetworkFailure extends ApiFailure {
  const NetworkFailure();
}

final class TimeoutFailure extends ApiFailure {
  const TimeoutFailure();
}

final class ServerFailure extends ApiFailure {
  const ServerFailure({required this.statusCode, this.message});

  final int statusCode;
  final String? message;
}

final class ParseFailure extends ApiFailure {
  const ParseFailure({this.details});

  final String? details;
}

final class BusinessFailure extends ApiFailure {
  const BusinessFailure({required this.reason, this.code});

  final String reason;
  final String? code;
}
