import 'package:bloc_test/bloc_test.dart';
import 'package:conversion_calculator/core/network/api_failure.dart';
import 'package:conversion_calculator/core/network/result.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/model/response/conversion_result.dart';
import 'package:conversion_calculator/data/repositories/conversion_repository.dart';
import 'package:conversion_calculator/presentation/cubits/calculator/calculator_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ConversionRepository {}

void main() {
  late _MockRepository repository;

  setUpAll(() {
    registerFallbackValue(CalculatorDto.mock());
  });

  setUp(() {
    repository = _MockRepository();
  });

  final dto = CalculatorDto.mock();

  blocTest<CalculatorCubit, CalculatorState>(
    'calculate emite Loading y Loaded cuando el repo tiene éxito',
    build: () {
      when(() => repository.calculate(any())).thenAnswer(
        (_) async => const HttpSuccess(
          ConversionResult(rate: 2.5, convertedAmount: 250),
        ),
      );
      return CalculatorCubit(repository: repository);
    },
    act: (cubit) => cubit.calculate(dto: dto),
    expect: () => [
      const CalculatorLoading(),
      const CalculatorLoaded(rate: 2.5, convertedAmount: 250),
    ],
    verify: (_) {
      verify(() => repository.calculate(dto)).called(1);
    },
  );

  blocTest<CalculatorCubit, CalculatorState>(
    'calculate emite Loading y Error con mensaje de red',
    build: () {
      when(() => repository.calculate(any())).thenAnswer(
        (_) async => const HttpError(NetworkFailure()),
      );
      return CalculatorCubit(repository: repository);
    },
    act: (cubit) => cubit.calculate(dto: dto),
    expect: () => [
      const CalculatorLoading(),
      const CalculatorError('Sin conexión. Revisá tu internet.'),
    ],
  );

  blocTest<CalculatorCubit, CalculatorState>(
    'calculate mapea BusinessFailure al reason',
    build: () {
      when(() => repository.calculate(any())).thenAnswer(
        (_) async => const HttpError(
          BusinessFailure(reason: 'Saldo insuficiente'),
        ),
      );
      return CalculatorCubit(repository: repository);
    },
    act: (cubit) => cubit.calculate(dto: dto),
    expect: () => [
      const CalculatorLoading(),
      const CalculatorError('Saldo insuficiente'),
    ],
  );
}
