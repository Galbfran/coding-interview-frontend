import 'package:flutter/material.dart';

abstract final class CalculatorBackgroundColors {
  /// Cielo pastel (referencia pantalla final).
  static const Color sky = Color(0xFFE8F6F7);

  /// Naranja/ámbar del arco lateral (alineado al botón “Cambiar” del mockup).
  static const Color accentOrange = Color(0xFFF5A623);
}

class CalculatorScreenBackgroundPainter extends CustomPainter {
  const CalculatorScreenBackgroundPainter();

  // --- Tres puntos (fracciones de W y H) que definen el borde naranja ---

  /// Superior: inicio en el borde de arriba, desde esta X hacia la derecha es naranja.
  static const double topXFactor = 0.70;

  /// Intermedio: “tira” de la curva hacia la izquierda (punto de control cuadrático).
  static const double midXFactor = 0.35;
  static const double midYFactor = 0.4;

  /// Inferior: fin en el borde derecho a esta altura (no llega al pie de pantalla).
  static const double bottomYFactor = 0.85;

  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..color = CalculatorBackgroundColors.sky
      ..isAntiAlias = true;
    canvas.drawRect(Offset.zero & size, skyPaint);

    final w = size.width;
    final h = size.height;

    final top = Offset(w * topXFactor, 0);
    final mid = Offset(w * midXFactor, h * midYFactor);
    final bottom = Offset(w, h * bottomYFactor);

    final orangePath = Path()
      ..moveTo(w, 0)
      ..lineTo(top.dx, top.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, bottom.dx, bottom.dy)
      ..lineTo(w, 0)
      ..close();

    final orangePaint = Paint()
      ..color = CalculatorBackgroundColors.accentOrange
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawPath(orangePath, orangePaint);
  }

  @override
  bool shouldRepaint(covariant CalculatorScreenBackgroundPainter oldDelegate) =>
      false;
}

class CalculatorScreenBackground extends StatelessWidget {
  const CalculatorScreenBackground({super.key, this.child});

  /// Hijo opcional encima del fondo. Si es null, se usa [SizedBox.expand] para que
  /// el [CustomPaint] reciba el tamaño del padre (un [SizedBox.shrink] deja size 0).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const CalculatorScreenBackgroundPainter(),
      child: child ?? const SizedBox.expand(),
    );
  }
}
