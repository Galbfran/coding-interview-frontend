import 'package:flutter/material.dart';

/// Medidas del formulario de la calculadora: el selector es más compacto y con
/// borde más grueso que el campo de monto (mock screen_1).
abstract final class CalculatorFormTokens {
  static const double amountBorderRadius = 16;
  static const double amountBorderWidth = 1;
  static const double amountBorderWidthFocused = 1.5;

  /// Radio grande → forma de cápsula (semicírculos en los extremos).
  static const double selectorBorderRadius = 999;

  static const double selectorBorderWidth = 2;

  /// Padding del monto; vertical equilibrado para centrar mejor el texto en el campo.
  static const EdgeInsets amountContentPadding = EdgeInsets.fromLTRB(
    16,
    15,
    16,
    15,
  );

  static const double exchangeButtonLabelFontSize = 17;

  static const double exchangeButtonElevation = 3.5;

  static const EdgeInsets selectorPillPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 8,
  );

  /// Separación respecto al borde redondeado de la cápsula (etiquetas + filas de moneda).
  static const double selectorHorizontalInset = 22;

  /// Aire hacia el centro, entre el contenido y el botón swap.
  static const double selectorPillInnerGap = 12;

  static const double selectorMinHeight = 44;
  static const double selectorIconSize = 24;
  static const double selectorLabelFontSize = 14;

  static const double swapButtonDiameter = 40;

  /// Escala extra para que el botón sobresalga del borde del selector (mock).
  /// Sin offset vertical: así el solapamiento es simétrico arriba y abajo.
  static const double swapButtonVisualScale = 1.32;

  /// Espacio superior del selector para que el borde quede a la altura del texto TENGO/QUIERO.
  static const double selectorLabelBorderOverlap = 10;

  /// Ajuste fino vertical de las etiquetas sobre la línea [accent].
  static const double selectorLabelTop = 0;

  /// Espacio antes y después del texto TENGO / QUIERO (sobre el borde).
  static const double selectorEdgeLabelHorizontalPadding = 8;
}
