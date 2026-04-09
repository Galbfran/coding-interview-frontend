import 'package:conversion_calculator/core/utils/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl {
    try {
      final url = dotenv.env['BASE_URL'] ?? "defaultBaseUrl";
      return url;
    } catch (error) {
     appLogger.e(error);
     return "defaultBaseUrl";
    }
  }
}
