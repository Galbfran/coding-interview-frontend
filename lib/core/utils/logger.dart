import 'package:logger/logger.dart';

/// Logger de consola (p. ej. interceptor de Dio en debug).
final appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 100,
  ),
);
