import 'package:conversion_calculator/core/network/api_failure.dart';
import 'package:conversion_calculator/core/network/dio_client.dart';
import 'package:conversion_calculator/core/network/result.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/model/response/recommendation_response.dart';
import 'package:dio/dio.dart';

class RecommendationsRemoteDataSource {
  const RecommendationsRemoteDataSource({required this.client});

  final DioClient client;


  Future<Result<RecommendationResponse>> getRecommendations(
    CalculatorDto calculateDto,
  ) async {
    try {
      final response = await client.request<Map<String, dynamic>>(
        '/recommendations',
        method: 'GET',
        queryParameters: calculateDto.toQueryParameters(),
      );

      final body = response.data;
      if (body == null) {
        return const HttpError(ParseFailure(details: 'Respuesta vacía del servidor.'));
      }

      if (body['error'] != null) {
        final err = body['error'] as Map<String, dynamic>?;
        return HttpError(
          BusinessFailure(
            reason: err?['message']?.toString() ?? 'Error de negocio desconocido.',
            code: err?['code']?.toString(),
          ),
        );
      }

      return HttpSuccess(RecommendationResponse.fromJson(body));
    } on DioException catch (e) {
      return HttpError(_mapDioException(e));
    } on FormatException catch (e) {
      return HttpError(ParseFailure(details: e.message));
    } catch (e) {
      return HttpError(ServerFailure(statusCode: -1, message: e.toString()));
    }
  }

  ApiFailure _mapDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const TimeoutFailure(),
      DioExceptionType.connectionError => const NetworkFailure(),
      DioExceptionType.badResponse => ServerFailure(
          statusCode: e.response?.statusCode ?? -1,
          message: e.response?.data?.toString(),
        ),
      _ => ServerFailure(
          statusCode: -1,
          message: e.message,
        ),
    };
  }
}
