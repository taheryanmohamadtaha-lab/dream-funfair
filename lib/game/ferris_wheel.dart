import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'park_game.dart';

class FerrisWheel extends PositionComponent with HasGameReference<ParkGame> {
  static const double radius = 190;
  static const int cabins = 12;
  double ang = 0;
  double speed = 0.12;
  double time = 0;

  FerrisWheel()
      : super(position: Vector2(1750, 420), size: Vector2.all(420), anchor: Anchor.center, priority: 690);

  Vector2 cabinPos(int i) {
    final a = ang + i * 2 * math.pi / cabins;
    return position + Vector2(math.cos(a), math.sin(a)) * radius + Vector2(0, 22);
  }

  @override
  void update(double dt) {
    ang += speed * dt;
    time += dt;
  }

  @override
  void render(Canvas c) {
    final p = Paint()..isAntiAlias = true;
    final cx = size.x / 2, cy = size.y / 2;

    // legs
    final leg = Paint()
      ..color = const Color(0xFF5C6BC0)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    c.drawLine(Offset(cx, cy), Offset(cx - 120, cy + 262), leg);
    c.drawLine(Offset(cx, cy), Offset(cx + 120, cy + 262), leg);
    leg.strokeWidth = 6;
    c.drawLine(Offset(cx - 70, cy + 152), Offset(cx + 70, cy + 152), leg);
    p.color = Colors.black26;
    c.drawOval(Rect.fromCenter(center: Offset(cx, cy + 266), width: 300, height: 26), p);

    // spokes
    final spoke = Paint()
      ..color = const Color(0xFFB39DDB)
      ..strokeWidth = 3;
    for (var i = 0; i < cabins; i++) {
      final a = ang + i * 2 * math.pi / cabins;
      c.drawLine(Offset(cx, cy), Offset(cx + math.cos(a) * radius, cy + math.sin(a) * radius), spoke);
    }

    // rim
    final rim = Paint()
      ..color = const Color(0xFF7E57C2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    c.drawCircle(Offset(cx, cy), radius, rim);
    c.drawCircle(Offset(cx, cy), radius - 26, rim..strokeWidth = 4);

    // blinking lights
    for (var i = 0; i < 24; i++) {
      final a = i * 2 * math.pi / 24 + ang * 0.5;
      final hue = (i * 15 + time * 70) % 360;
      p.color = HSVColor.fromAHSV(1, hue, 0.7, 1).toColor();
      c.drawCircle(Offset(cx + math.cos(a) * radius, cy + math.sin(a) * radius), 5, p);
    }

    // cabins (always hang upright)
    const cols = [Colors.redAccent, Colors.orange, Colors.yellow, Colors.green, Colors.cyan, Colors.blue];
    for (var i = 0; i < cabins; i++) {
      final a = ang + i * 2 * math.pi / cabins;
      final px = cx + math.cos(a) * radius, py = cy + math.sin(a) * radius;
      c.drawLine(Offset(px, py), Offset(px, py + 14), Paint()..color = Colors.white..strokeWidth = 2);
      p.color = cols[i % cols.length];
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(px - 17, py + 12, 34, 28), const Radius.circular(8)), p);
      p.color = Colors.white;
      c.drawRect(Rect.fromLTWH(px - 17, py + 12, 34, 6), p);
      p.color = const Color(0xAA81D4FA);
      c.drawRect(Rect.fromLTWH(px - 11, py + 21, 22, 11), p);
    }

    // hub
    p.color = Colors.amber;
    c.drawCircle(Offset(cx, cy), 16, p);
    p.color = Colors.deepOrange;
    c.drawCircle(Offset(cx, cy), 7, p);
  }
}
