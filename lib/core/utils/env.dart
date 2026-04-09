import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {

  static const String defaultBaseUrl =
      'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations';

  static String get baseUrl {
    try {
      final url = dotenv.env['BASE_URL'];
      if (url != null && url.isNotEmpty) return url;
    } catch (_) {
  
    }
    return defaultBaseUrl;
  }
}
