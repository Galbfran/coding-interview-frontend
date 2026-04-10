import 'package:conversion_calculator/core/network/api_failure.dart';

/// Tipo resultado que encapsula éxito ([HttpSuccess]) o fallo ([HttpError]).
///
/// Uso:
/// ```dart
/// switch (result) {
///   case HttpSuccess(:final value) => // usar value
///   case HttpError(:final failure) => // manejar failure
/// }
/// ```
sealed class Result<T> {
  const Result();
}

/// Resultado exitoso con el valor [T].
final class HttpSuccess<T> extends Result<T> {
  const HttpSuccess(this.value);
  final T value;
}

/// Resultado fallido con la causa [ApiFailure].
final class HttpError<T> extends Result<T> {
  const HttpError(this.failure);
  final ApiFailure failure;
}
