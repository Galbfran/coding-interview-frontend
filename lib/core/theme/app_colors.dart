import 'package:flutter/material.dart';

/// Paleta centralizada (calculadora y fondo).
abstract final class AppColors {
  /// Naranja / ámbar: botón Cambiar, bordes, íconos, arco del fondo.
  static const Color accent = Color(0xFFF5A623);

  /// Cielo pastel del [CustomPainter] de fondo.
  static const Color sky = Color(0xFFE8F6F7);

  /// Etiquetas secundarias (TENGO, QUIERO, filas de resumen).
  static const Color labelGrey = Color(0xFF757575);

  /// Superficie de card y similares.
  static const Color surface = Color(0xFFFFFFFF);

  /// Texto / íconos sobre [accent].
  static const Color onAccent = Color(0xFFFFFFFF);

  /// Valores en filas de resumen (equivalente a [Colors.black87]).
  static const Color textStrong = Color(0xDD000000);

  /// Sombra suave bajo cards (equivalente a [Colors.black26]).
  static const Color shadow = Color(0x42000000);
}
