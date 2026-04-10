import 'package:conversion_calculator/core/network/result.dart';
import 'package:conversion_calculator/data/datasources/recommendations_remote_datasource.dart';
import 'package:conversion_calculator/data/model/enum/change_type.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/model/response/conversion_result.dart';
import 'package:conversion_calculator/data/repositories/conversion_repository.dart';

class ConversionRepositoryImpl implements ConversionRepository {
  const ConversionRepositoryImpl({required this.dataSource});

  final RecommendationsRemoteDataSource dataSource;

  @override
  Future<Result<ConversionResult>> calculate(CalculatorDto dto) async {
    final result = await dataSource.getRecommendations(dto);

    return switch (result) {
      HttpSuccess(:final value) => HttpSuccess(
          ConversionResult(
            rate: value.fiatToCryptoExchangeRate,
            convertedAmount: _applyFormula(
              amount: dto.amount,
              rate: value.fiatToCryptoExchangeRate,
              changeType: dto.changeType,
            ),
          ),
        ),
      HttpError(:final failure) => HttpError(failure),
    };
  }

  /// type=0 (CRYPTO→FIAT): fiat = crypto * rate
  /// type=1 (FIAT→CRYPTO): crypto = fiat / rate
  double _applyFormula({
    required double amount,
    required double rate,
    required ChangeType changeType,
  }) =>
      switch (changeType) {
        ChangeType.cryptoToFiat => amount * rate,
        ChangeType.fiatToCrypto => amount / rate,
      };
}
