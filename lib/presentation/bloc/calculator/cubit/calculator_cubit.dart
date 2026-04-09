import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:conversion_calculator/core/network/dio_client.dart';
import 'package:conversion_calculator/core/utils/env.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit({required DioClient dioClient})
      : super(const CalculatorInitial());

  final DioClient dioClient = DioClient(baseUrl: Env.baseUrl);

  Future<void> getRecommendations() async {
    emit(const CalculatorLoading());
    try {
      final response = await dioClient.request<dynamic>(
        '',
        method: 'GET',
        queryParameters: <String, dynamic>{
          'type': 0,
          'cryptoCurrencyId': 'TATUM-TRON-USDT',
          'fiatCurrencyId': 'PEN',
          'amount': 100,
          'amountCurrencyId': 100,
        },
      );

      final data = response.data;
      final text = _encodeBody(data);
      emit(CalculatorLoaded(jsonPreview: text));
    } on DioException catch (e) {
      final body = e.response?.data;
      final text = body != null ? _encodeBody(body) : (e.message ?? 'Error de red');
      emit(CalculatorError(text));
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  String _encodeBody(dynamic data) {
    if (data is Map || data is List) {
      return const JsonEncoder.withIndent('  ').convert(data);
    }
    return data?.toString() ?? '';
  }
}
