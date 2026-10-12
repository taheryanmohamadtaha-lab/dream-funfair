import 'dart:math' as math;
import 'package:flutter/material.dart';

const outfitColors = <Color>[
  Color(0xFFE53935),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFFFDD835),
  Color(0xFF8E24AA),
  Color(0xFFFB8C00),
];

/// Draws one of 6 cartoon characters. [t] is 0..1 animation phase.
class CharacterPainter extends CustomPainter {
  final int type;
  final Color outfit;
  final double t;
  final bool walking;
  CharacterPainter(this.type, this.outfit, this.t, this.walking);

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height, cx = w / 2;
    final p = Paint()..isAntiAlias = true;

    p.color = Colors.black26;
    c.drawOval(Rect.fromCenter(center: Offset(cx, h * 0.95), width: w * 0.55, height: h * 0.06), p);

    final swing = walking ? math.sin(t * 4 * math.pi) : 0.0;
    final bob = walking ? math.sin(t * 8 * math.pi).abs() * h * 0.025 : 0.0;
    c.save();
    c.translate(0, -bob);

    final legPaint = Paint()
      ..color = const Color(0xFF37474F)
      ..strokeWidth = w * 0.11
      ..strokeCap = StrokeCap.round;
    for (final side in [-1.0, 1.0]) {
      final dx = cx + side * w * 0.1;
      final off = swing * side * w * 0.07;
      c.drawLine(Offset(dx, h * 0.68), Offset(dx + off, h * 0.88), legPaint);
      p.color = const Color(0xFF212121);
      c.drawOval(Rect.fromCenter(center: Offset(dx + off + side * 2, h * 0.9), width: w * 0.17, height: h * 0.05), p);
    }

    final armPaint = Paint()
      ..color = outfit
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;
    for (final side in [-1.0, 1.0]) {
      final off = -swing * side * w * 0.06;
      c.drawLine(Offset(cx + side * w * 0.2, h * 0.46),
          Offset(cx + side * w * 0.28 + off, h * 0.62), armPaint);
    }

    p.color = outfit;
    c.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(cx - w * 0.21, h * 0.4, cx + w * 0.21, h * 0.7), Radius.circular(w * 0.1)),
        p);
    p.color = Colors.white24;
    c.drawRect(Rect.fromLTRB(cx - w * 0.21, h * 0.5, cx + w * 0.21, h * 0.54), p);

    final hc = Offset(cx, h * 0.26);
    final r = w * 0.25;
    const skins = [
      Color(0xFFFFD2A6), Color(0xFFFFD2A6), Color(0xFFB0BEC5),
      Color(0xFFFFB74D), Color(0xFFECEFF1), Color(0xFFFFF3E0),
    ];

    if (type == 1) {
      p.color = const Color(0xFF6D4C41);
      c.drawCircle(hc + Offset(-r * 1.05, r * 0.3), r * 0.35, p);
      c.drawCircle(hc + Offset(r * 1.05, r * 0.3), r * 0.35, p);
    }
    if (type == 3) {
      p.color = skins[3];
      for (final sd in [-1.0, 1.0]) {
        final path = Path()
          ..moveTo(hc.dx + sd * r * 0.2, hc.dy - r * 0.8)
          ..lineTo(hc.dx + sd * r * 0.95, hc.dy - r * 1.25)
          ..lineTo(hc.dx + sd * r * 0.95, hc.dy - r * 0.2)
          ..close();
        c.drawPath(path, p);
      }
    }
    if (type == 5) {
      const rainbow = [Colors.red, Colors.orange, Colors.green, Colors.blue];
      for (var i = 0; i < 4; i++) {
        p.color = rainbow[i];
        final sd = i < 2 ? -1.0 : 1.0;
        c.drawCircle(hc + Offset(sd * r * (0.9 + (i % 2) * 0.35), -r * 0.2 + (i % 2) * r * 0.4), r * 0.3, p);
      }
    }

    p.color = skins[type];
    if (type == 2) {
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: hc, width: r * 1.9, height: r * 1.7), Radius.circular(r * 0.3)), p);
      c.drawLine(hc + Offset(0, -r * 0.85), hc + Offset(0, -r * 1.35),
          Paint()..color = Colors.grey..strokeWidth = 3);
      p.color = Colors.redAccent;
      c.drawCircle(hc + Offset(0, -r * 1.4), 5, p);
    } else if (type == 4) {
      p.color = Colors.white;
      c.drawCircle(hc, r * 1.1, p);
      p.color = const Color(0xFF263238);
      c.drawOval(Rect.fromCenter(center: hc, width: r * 1.6, height: r * 1.2), p);
      p.color = Colors.lightBlueAccent.withAlpha(120);
      c.drawOval(Rect.fromCenter(center: hc + Offset(-r * 0.25, -r * 0.2), width: r * 0.5, height: r * 0.3), p);
    } else {
      c.drawCircle(hc, r, p);
    }

    if (type != 4) {
      p.color = type == 2 ? Colors.cyanAccent : Colors.black87;
      final ey = hc.dy - r * 0.1;
      if (type == 2) {
        c.drawRect(Rect.fromCenter(center: Offset(hc.dx - r * 0.4, ey), width: r * 0.3, height: r * 0.3), p);
        c.drawRect(Rect.fromCenter(center: Offset(hc.dx + r * 0.4, ey), width: r * 0.3, height: r * 0.3), p);
      } else {
        c.drawCircle(Offset(hc.dx - r * 0.38, ey), r * 0.12, p);
        c.drawCircle(Offset(hc.dx + r * 0.38, ey), r * 0.12, p);
      }
      final smile = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      c.drawArc(Rect.fromCenter(center: hc + Offset(0, r * 0.3), width: r * 0.8, height: r * 0.5), 0.2, math.pi - 0.4, false, smile);
    }

    if (type == 0) {
      p.color = const Color(0xFF4E342E);
      c.drawArc(Rect.fromCircle(center: hc, radius: r * 1.02), math.pi * 1.05, math.pi * 0.9, true, p);
    }
    if (type == 1) {
      p.color = const Color(0xFF6D4C41);
      c.drawArc(Rect.fromCircle(center: hc, radius: r * 1.02), math.pi * 1.0, math.pi, true, p);
      p.color = Colors.pinkAccent;
      c.drawCircle(hc + Offset(r * 0.6, -r * 0.8), r * 0.22, p);
    }
    if (type == 3) {
      final wh = Paint()..color = Colors.black54..strokeWidth = 1.8;
      for (final sd in [-1.0, 1.0]) {
        c.drawLine(hc + Offset(sd * r * 0.4, r * 0.25), hc + Offset(sd * r * 1.1, r * 0.1), wh);
        c.drawLine(hc + Offset(sd * r * 0.4, r * 0.35), hc + Offset(sd * r * 1.1, r * 0.4), wh);
      }
      p.color = Colors.pinkAccent;
      c.drawCircle(hc + Offset(0, r * 0.12), r * 0.1, p);
    }
    if (type == 5) {
      p.color = Colors.red;
      c.drawCircle(hc + Offset(0, r * 0.12), r * 0.2, p);
      p.color = Colors.deepPurple;
      final hat = Path()
        ..moveTo(hc.dx - r * 0.5, hc.dy - r * 0.85)
        ..lineTo(hc.dx, hc.dy - r * 1.9)
        ..lineTo(hc.dx + r * 0.5, hc.dy - r * 0.85)
        ..close();
      c.drawPath(hat, p);
    }

    c.restore();
  }

  @override
  bool shouldRepaint(CharacterPainter o) =>
      o.t != t || o.type != type || o.outfit != outfit || o.walking != walking;
}
