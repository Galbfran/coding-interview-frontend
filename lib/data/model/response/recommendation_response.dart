/// Modelo de respuesta del endpoint `/recommendations`.
///
/// Solo se mapean los campos que la app usa, siguiendo:
/// `data.byPrice.fiatToCryptoExchangeRate`
class RecommendationResponse {
  const RecommendationResponse({required this.fiatToCryptoExchangeRate});

  final double fiatToCryptoExchangeRate;

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final byPrice = data?['byPrice'] as Map<String, dynamic>?;
    final rate = byPrice?['fiatToCryptoExchangeRate'];

    if (rate == null) {
      throw const FormatException(
        'Campo fiatToCryptoExchangeRate ausente en la respuesta del API.',
      );
    }

    // El API devuelve fiatToCryptoExchangeRate como String ("3.363"), no como num.
    return RecommendationResponse(
      fiatToCryptoExchangeRate: double.parse(rate.toString()),
    );
  }
}
