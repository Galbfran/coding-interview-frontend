import 'package:conversion_calculator/data/model/response/recommendation_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecommendationResponse.fromJson', () {
    test('parsea tasa como String', () {
      final json = {
        'data': {
          'byPrice': {'fiatToCryptoExchangeRate': '25.5'},
        },
      };
      final r = RecommendationResponse.fromJson(json);
      expect(r.fiatToCryptoExchangeRate, 25.5);
    });

    test('parsea tasa como num', () {
      final json = {
        'data': {
          'byPrice': {'fiatToCryptoExchangeRate': 10},
        },
      };
      final r = RecommendationResponse.fromJson(json);
      expect(r.fiatToCryptoExchangeRate, 10.0);
    });

    test('lanza FormatException si falta fiatToCryptoExchangeRate', () {
      expect(
        () => RecommendationResponse.fromJson(<String, dynamic>{
          'data': <String, dynamic>{
            'byPrice': <String, dynamic>{},
          },
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
