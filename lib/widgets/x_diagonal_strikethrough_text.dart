import 'package:flutter/material.dart';

/// Type of diagonal strikethrough line rendered over the text.
///
/// * [topBottom] – draws a line starting from the **top-left** to the **bottom-right**.
/// * [bottomTop] – draws a line starting from the **bottom-left** to the **top-right**.
enum XDiagonalStrikethroughType { topBottom, bottomTop }

/// A text widget with a diagonal strikethrough line drawn across it.
///
/// This widget overlays a custom diagonal line above the text using a [CustomPainter],
/// allowing more flexibility compared to the default text decoration.
///
/// It supports:
/// - Custom line color
/// - Custom stroke width
/// - Two diagonal orientations
/// - Custom text style
///
/// Example:
/// ```dart
/// XDiagonalStrikethroughText(
///   "Discounted",
///   style: TextStyle(fontSize: 18, color: Colors.red),
///   lineColor: Colors.red,
///   strokeWidth: 2,
///   diagonalType: XDiagonalStrikethroughType.bottomTop,
/// );
/// ```
///
/// This is often used for pricing text in e-commerce apps (e.g., old price).
class XDiagonalStrikethroughText extends StatelessWidget {
  /// Text to be displayed with strikethrough.
  final String text;

  /// Style for the text.
  final TextStyle? style;

  /// Color of the diagonal line.
  final Color lineColor;

  /// Thickness of the strikethrough line.
  final double strokeWidth;

  /// Direction/orientation of the diagonal line.
  final XDiagonalStrikethroughType diagonalType;

  /// Creates a text widget with a diagonal strikethrough line.
  const XDiagonalStrikethroughText(
    this.text, {
    super.key,
    this.style,
    this.lineColor = Colors.black,
    this.strokeWidth = 2.0,
    this.diagonalType = XDiagonalStrikethroughType.bottomTop,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main text
        Text(text, style: style),

        // Diagonal line overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _XDiagonalLinePainter(
              diagonalType: diagonalType,
              color: lineColor,
              strokeWidth: strokeWidth,
            ),
          ),
        ),
      ],
    );
  }
}

/// Painter responsible for drawing the diagonal strikethrough line.
///
/// You usually do not use this directly—it's used internally by [XDiagonalStrikethroughText].
class _XDiagonalLinePainter extends CustomPainter {
  /// Color of the diagonal line.
  final Color color;

  /// Thickness of the diagonal line.
  final double strokeWidth;

  /// Orientation of the diagonal line (top-to-bottom or bottom-to-top).
  final XDiagonalStrikethroughType diagonalType;

  /// Creates a painter to draw a diagonal line.
  _XDiagonalLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.diagonalType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      diagonalType == XDiagonalStrikethroughType.bottomTop
          ? Offset(0, size.height)
          : Offset(0, 0),
      diagonalType == XDiagonalStrikethroughType.bottomTop
          ? Offset(size.width, 0)
          : Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
