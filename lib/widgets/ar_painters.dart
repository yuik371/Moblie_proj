import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// AR 화면 배경의 원근 격자와 추적 점을 그리는 CustomPainter입니다.
class ArGridPainter extends CustomPainter {
  ArGridPainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(.12)
      ..strokeWidth = 1;
    for (var i = -4; i < 12; i++) {
      final x = i * 54.0;
      canvas.drawLine(Offset(x, 0), Offset(x + size.height * .25, size.height), p);
    }
    for (var i = 0; i < 14; i++) {
      final y = i * 44.0 + math.sin(phase * math.pi * 2) * 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
    p.color = orange.withOpacity(.45);
    canvas.drawCircle(Offset(size.width * .2, size.height * .28), 4, p);
    canvas.drawCircle(Offset(size.width * .82, size.height * .48), 3, p);
  }

  @override
  bool shouldRepaint(covariant ArGridPainter oldDelegate) => true;
}

// AR 화면 중앙에서 상품 위치를 조준하는 십자 표시를 그립니다.
class ReticlePainter extends CustomPainter {
  const ReticlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    const r = 42.0;
    canvas.drawLine(Offset(center.dx - r, center.dy - r), Offset(center.dx - r + 14, center.dy - r), p);
    canvas.drawLine(Offset(center.dx - r, center.dy - r), Offset(center.dx - r, center.dy - r + 14), p);
    canvas.drawLine(Offset(center.dx + r, center.dy + r), Offset(center.dx + r - 14, center.dy + r), p);
    canvas.drawLine(Offset(center.dx + r, center.dy + r), Offset(center.dx + r, center.dy + r - 14), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
