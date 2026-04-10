import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static const String _fallbackBaseUrl =
      'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations';

  /// URL base del API. Lee de `.env` (clave `BASE_URL`).
  /// Si no está disponible usa la URL de fallback del README.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? _fallbackBaseUrl;
}
