import 'package:conversion_calculator/core/network/result.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/model/response/conversion_result.dart';

/// Contrato que el cubit conoce. No depende de Dio ni del datasource.
abstract class ConversionRepository {
  Future<Result<ConversionResult>> calculate(CalculatorDto dto);
}
