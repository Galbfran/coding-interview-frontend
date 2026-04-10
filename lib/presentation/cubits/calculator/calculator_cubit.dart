import 'package:bloc/bloc.dart';
import 'package:conversion_calculator/core/network/api_failure.dart';
import 'package:conversion_calculator/core/network/result.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/repositories/conversion_repository.dart';
import 'package:equatable/equatable.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit({required this.repository}) : super(const CalculatorInitial());

  final ConversionRepository repository;

  Future<void> calculate({required CalculatorDto dto}) async {
    emit(const CalculatorLoading());

    final result = await repository.calculate(dto);

    switch (result) {
      case HttpSuccess(:final value):
        emit(CalculatorLoaded(
          rate: value.rate,
          convertedAmount: value.convertedAmount,
        ));
      case HttpError(:final failure):
        emit(CalculatorError(_mapFailureMessage(failure)));
    }
  }

  String _mapFailureMessage(ApiFailure failure) => switch (failure) {
        NetworkFailure() => 'Sin conexión. Revisá tu internet.',
        TimeoutFailure() => 'La solicitud tardó demasiado. Intentá de nuevo.',
        ServerFailure(:final statusCode) =>
          'Error del servidor ($statusCode). Intentá más tarde.',
        ParseFailure() => 'Respuesta inesperada del servidor.',
        BusinessFailure(:final reason) => reason,
      };
}
