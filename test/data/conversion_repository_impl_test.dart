import 'package:conversion_calculator/core/network/api_failure.dart';
import 'package:conversion_calculator/core/network/result.dart';
import 'package:conversion_calculator/data/datasources/recommendations_remote_datasource.dart';
import 'package:conversion_calculator/data/model/enum/change_type.dart';
import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/model/response/recommendation_response.dart';
import 'package:conversion_calculator/data/repositories/conversion_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataSource extends Mock implements RecommendationsRemoteDataSource {}

void main() {
  late _MockDataSource dataSource;
  late ConversionRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(CalculatorDto.mock());
  });

  setUp(() {
    dataSource = _MockDataSource();
    repository = ConversionRepositoryImpl(dataSource: dataSource);
  });

  CalculatorDto dto({
    required ChangeType changeType,
    double amount = 10,
  }) {
    return CalculatorDto(
      changeType: changeType,
      cryptoCurrencyId: CryptoCurrencyId.tatumTronUsdt,
      fiatCurrencyId: FiatCurrencyId.ves,
      amount: amount,
      amountCurrencyId: 100,
    );
  }

  group('ConversionRepositoryImpl.calculate', () {
    test('CRYPTO→FIAT: convertedAmount = amount * rate', () async {
      when(() => dataSource.getRecommendations(any())).thenAnswer(
        (_) async => const HttpSuccess(
          RecommendationResponse(fiatToCryptoExchangeRate: 4),
        ),
      );

      final result = await repository.calculate(
        dto(changeType: ChangeType.cryptoToFiat, amount: 10),
      );

      expect(result, isA<HttpSuccess>());
      final success = result as HttpSuccess;
      expect(success.value.rate, 4);
      expect(success.value.convertedAmount, 40);
      verify(() => dataSource.getRecommendations(any())).called(1);
    });

    test('FIAT→CRYPTO: convertedAmount = amount / rate', () async {
      when(() => dataSource.getRecommendations(any())).thenAnswer(
        (_) async => const HttpSuccess(
          RecommendationResponse(fiatToCryptoExchangeRate: 25),
        ),
      );

      final result = await repository.calculate(
        dto(changeType: ChangeType.fiatToCrypto, amount: 100),
      );

      expect(result, isA<HttpSuccess>());
      final success = result as HttpSuccess;
      expect(success.value.rate, 25);
      expect(success.value.convertedAmount, 4);
    });

    test('propaga HttpError del datasource', () async {
      when(() => dataSource.getRecommendations(any())).thenAnswer(
        (_) async => const HttpError(NetworkFailure()),
      );

      final result = await repository.calculate(
        dto(changeType: ChangeType.cryptoToFiat),
      );

      expect(result, isA<HttpError>());
      final err = result as HttpError;
      expect(err.failure, isA<NetworkFailure>());
    });
  });
}
