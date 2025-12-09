import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A horizontal double-dashed divider line drawn using a custom painter.
///
/// This widget renders **two dashed horizontal lines** stacked vertically
/// with a configurable spacing between them.
///
/// Common use cases:
/// - Section separators
/// - Receipt-style or ticket-style dividers
/// - Decorative boundaries in UI layouts
///
/// Features:
/// - Custom dash width and gap
/// - Adjustable stroke width
/// - Custom color
/// - Custom spacing between the two dashed lines
///
/// Example:
/// ```dart
/// XDoubleDashedLine(
///   dashWidth: 6,
///   dashGap: 4,
///   strokeWidth: 1,
///   color: Colors.grey,
///   spacing: 4,
/// );
/// ```
class XDoubleDashedLine extends StatelessWidget {
  /// Length of each dash segment.
  final double dashWidth;

  /// Gap between dash segments.
  final double dashGap;

  /// Thickness of the dashed lines.
  final double strokeWidth;

  /// Color of the dashed lines.
  final Color color;

  /// Vertical spacing between the two dashed lines.
  final double spacing;

  /// Creates a horizontal double-dashed divider.
  const XDoubleDashedLine({
    super.key,
    this.dashWidth = 6,
    this.dashGap = 4,
    this.strokeWidth = .8,
    this.color = Colors.black54,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CustomPaint(
        size: Size(double.infinity, spacing + strokeWidth * 2),
        painter: _XDoubleDashedDividerPainter(
          dashWidth: dashWidth,
          dashGap: dashGap,
          strokeWidth: strokeWidth,
          color: color,
          spacing: spacing,
        ),
      ),
    );
  }
}

/// Internal painter responsible for drawing both dashed lines.
///
/// This class is used by [XDoubleDashedLine] and usually should not be
/// instantiated directly.
class _XDoubleDashedDividerPainter extends CustomPainter {
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;
  final Color color;
  final double spacing;

  _XDoubleDashedDividerPainter({
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
    required this.color,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final y1 = strokeWidth / 2;
    final y2 = y1 + spacing;

    // First dashed line
    _drawDashedLine(canvas, Offset(0, y1), Offset(size.width, y1), paint);

    // Second dashed line below it
    _drawDashedLine(canvas, Offset(0, y2), Offset(size.width, y2), paint);
  }

  /// Draws a single dashed line from [p1] to [p2].
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final total = math.sqrt(dx * dx + dy * dy);

    final ux = dx / total; // normalized x direction
    final uy = dy / total; // normalized y direction

    double drawn = 0;
    bool draw = true;
    var current = p1;

    while (drawn < total) {
      final len = draw ? dashWidth : dashGap;
      final step = math.min(len, total - drawn);
      final next = Offset(current.dx + ux * step, current.dy + uy * step);

      if (draw) canvas.drawLine(current, next, paint);

      current = next;
      drawn += step;
      draw = !draw; // alternate dash/gap
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
