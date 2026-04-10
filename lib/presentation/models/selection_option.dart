import 'package:flutter/foundation.dart';

/// Opción mostrada en el bottom sheet de monedas (fiat o crypto).
@immutable
class SelectionOption {
  const SelectionOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  /// Valor devuelto al elegir (p. ej. [FiatCurrencyId.asApiId] o [CryptoCurrencyId.asApiId]).
  final String code;

  final String title;
  final String subtitle;

  /// Ruta bajo `assets/` para [Image.asset].
  final String assetPath;
}
