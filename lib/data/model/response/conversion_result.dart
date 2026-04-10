/// Resultado de la conversión listo para mostrar en la UI.
class ConversionResult {
  const ConversionResult({
    required this.rate,
    required this.convertedAmount,
  });

  /// Tasa `fiatToCryptoExchangeRate` devuelta por el API.
  final double rate;

  /// Monto ya convertido según el tipo de cambio y la dirección de la operación.
  final double convertedAmount;
}
