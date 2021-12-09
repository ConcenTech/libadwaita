import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TrianglePainter oldDelegate) => false;
}

class TriangleShadowPainter extends CustomPainter {
  final Color color;

  TriangleShadowPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = Paint()
    //   ..color = color
    //   ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.grey.withAlpha(50), 4.0, false);
  }

  @override
  bool shouldRepaint(TriangleShadowPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TriangleShadowPainter oldDelegate) => false;
}