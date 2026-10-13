import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../core/strings.dart';
import 'draw_util.dart';
import 'park_game.dart';
import 'world_consts.dart';

bool onPath(double x, double y) {
  if (x > 1030 && x < 1370 && y > 200 && y < gateY + 30) return true;
  if (y > 680 && y < 920 && x > 100 && x < 2300) return true;
  final dx = x - 1200, dy = y - 800;
  if (math.sqrt(dx * dx + dy * dy) < 300) return true;
  if (x > 740 && x < 1050 && y > 1040 && y < 1300) return true;
  if (x > 1440 && x < 2080 && y > 120 && y < 820) return true;
  return false;
}

/// Static scenery, recorded once into a Picture for speed.
class ParkMap extends PositionComponent {
  ParkMap() : super(priority: -100000);
  late final Picture _pic;

  @override
  Future<void> onLoad() async {
    final rec = PictureRecorder();
    _paint(Canvas(rec));
    _pic = rec.endRecording();
  }

  @override
  void render(Canvas canvas) => canvas.drawPicture(_pic);

  void _tree(Canvas c, Paint p, double x, double y) {
    p.color = Colors.black26;
    c.drawOval(Rect.fromCenter(center: Offset(x, y), width: 70, height: 22), p);
    p.color = const Color(0xFF6D4C41);
    c.drawRect(Rect.fromLTWH(x - 7, y - 40, 14, 40), p);
    p.color = const Color(0xFF2E7D32);
    c.drawCircle(Offset(x, y - 70), 34, p);
    p.color = const Color(0xFF43A047);
    c.drawCircle(Offset(x - 18, y - 52), 26, p);
    c.drawCircle(Offset(x + 18, y - 52), 26, p);
    p.color = const Color(0xFF66BB6A);
    c.drawCircle(Offset(x - 8, y - 80), 18, p);
  }

  void _paint(Canvas c) {
    final p = Paint()..isAntiAlias = true;
    final rnd = math.Random(7);

    // ground: outer green, lawn, road
    p.color = const Color(0xFF4C9A3A);
    c.drawRect(const Rect.fromLTWH(-1500, -1500, worldW + 3000, gateY + 1500), p);
    p.color = const Color(0xFF7CCB5A);
    c.drawRect(const Rect.fromLTWH(0, 0, worldW, gateY), p);
    p.color = const Color(0xFF6D6D80);
    c.drawRect(const Rect.fromLTWH(-1500, gateY, worldW + 3000, 1500), p);
    p.color = Colors.white70;
    for (double x = -200; x < worldW + 200; x += 120) {
      c.drawRect(Rect.fromLTWH(x, gateY + 130, 60, 8), p);
    }

    // grass patches
    for (var i = 0; i < 260; i++) {
      p.color = const Color(0x3358A83A);
      c.drawCircle(Offset(rnd.nextDouble() * worldW, rnd.nextDouble() * gateY),
          20 + rnd.nextDouble() * 30, p);
    }

    // paths
    final rects = <Rect>[
      Rect.fromLTRB(1070, 250, 1330, gateY),
      Rect.fromLTRB(150, 720, 2250, 880),
      Rect.fromLTRB(780, 1090, 1010, 1260),
      Rect.fromLTRB(1500, 600, 2000, 780),
    ];
    for (final r in rects) {
      p.color = const Color(0xFFD9B878);
      c.drawRRect(RRect.fromRectAndRadius(r.inflate(10), const Radius.circular(24)), p);
    }
    for (final r in rects) {
      p.color = const Color(0xFFF3D9A4);
      c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(20)), p);
    }
    p.color = const Color(0xFFD9B878);
    c.drawCircle(const Offset(1200, 800), 265, p);
    p.color = const Color(0xFFEBC987);
    c.drawCircle(const Offset(1200, 800), 250, p);
    p.color = const Color(0xFFF7E3B5);
    c.drawCircle(const Offset(1200, 800), 215, p);

    // flowers
    const petals = [Colors.pinkAccent, Colors.yellowAccent, Colors.white, Colors.orangeAccent, Colors.purpleAccent];
    for (var i = 0; i < 260; i++) {
      final x = 20 + rnd.nextDouble() * (worldW - 40);
      final y = 20 + rnd.nextDouble() * (gateY - 60);
      if (onPath(x, y)) continue;
      p.color = petals[rnd.nextInt(petals.length)];
      c.drawCircle(Offset(x, y), 5, p);
      p.color = Colors.yellow.shade800;
      c.drawCircle(Offset(x, y), 2, p);
    }

    // trees
    final trees = <Offset>[];
    for (var i = 0; i < 600 && trees.length < 75; i++) {
      final x = 50 + rnd.nextDouble() * (worldW - 100);
      final y = 110 + rnd.nextDouble() * (gateY - 200);
      if (onPath(x, y)) continue;
      if (trees.any((t) => (t - Offset(x, y)).distance < 90)) continue;
      trees.add(Offset(x, y));
    }
    trees.sort((a, b) => a.dy.compareTo(b.dy));
    for (final t in trees) {
      _tree(c, p, t.dx, t.dy);
    }

    // fence (with gate gap)
    for (double x = 0; x < worldW; x += 26) {
      if (x > 1030 && x < 1370) continue;
      p.color = Colors.white;
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, gateY - 42, 12, 44), const Radius.circular(4)), p);
    }
    p.color = const Color(0xFFFFCDD2);
    c.drawRect(const Rect.fromLTWH(0, gateY - 30, 1030, 6), p);
    c.drawRect(const Rect.fromLTWH(1370, gateY - 30, worldW - 1370, 6), p);

    // big gate: two striped towers + banner
    for (final x in [1010.0, 1350.0]) {
      for (var i = 0; i < 6; i++) {
        p.color = i.isEven ? Colors.pinkAccent : Colors.yellowAccent;
        c.drawRect(Rect.fromLTWH(x, gateY - 190 + i * 32, 40, 32), p);
      }
      p.color = Colors.redAccent;
      c.drawCircle(Offset(x + 20, gateY - 200), 24, p);
    }
    p.color = const Color(0xFFFFFFFF);
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(1000, gateY - 252, 400, 66), const Radius.circular(22)), p);
    p.color = const Color(0xFF7C4DFF);
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(1006, gateY - 246, 388, 54), const Radius.circular(18)), p);
    drawText(c, tr('title'), const Offset(1200, gateY - 219), size: 30, center: true);
  }
}

class LampPosts extends PositionComponent with HasGameReference<ParkGame> {
  LampPosts() : super(priority: -50000);

  final List<Offset> _pts = [
    for (var y = 320.0; y <= 1380; y += 180) ...[Offset(1050, y), Offset(1350, y)],
    for (var x = 250.0; x <= 2200; x += 260) Offset(x, 700),
  ];

  @override
  void render(Canvas c) {
    final p = Paint();
    final d = game.tintDark;
    for (final o in _pts) {
      p.color = const Color(0xFF455A64);
      c.drawRect(Rect.fromLTWH(o.dx - 3, o.dy - 60, 6, 60), p);
      if (d > 0.3) {
        p.color = Color.fromARGB((d * 90).round(), 255, 230, 120);
        c.drawCircle(Offset(o.dx, o.dy - 66), 30, p);
      }
      p.color = d > 0.3 ? const Color(0xFFFFF59D) : const Color(0xFFFFE082);
      c.drawCircle(Offset(o.dx, o.dy - 66), 8, p);
    }
  }
}

class Fountain extends PositionComponent with HasGameReference<ParkGame> {
  Fountain()
      : super(position: Vector2(1200, 800), size: Vector2(240, 110), anchor: Anchor.center, priority: 800);

  @override
  void render(Canvas c) {
    final p = Paint()..isAntiAlias = true;
    final cx = size.x / 2, cy = size.y / 2;
    p.color = const Color(0xFF9E9E9E);
    c.drawOval(Rect.fromLTWH(0, 0, size.x, size.y), p);
    p.color = const Color(0xFF4FC3F7);
    c.drawOval(Rect.fromLTWH(12, 9, size.x - 24, size.y - 22), p);
    p.color = const Color(0xFFBDBDBD);
    c.drawRect(Rect.fromLTWH(cx - 8, cy - 40, 16, 40), p);
    final t = game.clock;
    p.color = Colors.white.withAlpha(220);
    for (var i = 0; i < 10; i++) {
      final a = i * 2 * math.pi / 10;
      final k = (t * 0.9 + i / 10) % 1;
      final x = cx + math.cos(a) * 60 * k;
      final y = cy + math.sin(a) * 18 * k - math.sin(math.pi * k) * 80;
      c.drawCircle(Offset(x, y), 3.5, p);
    }
    final h = 30 + math.sin(t * 3) * 6;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 3, cy - 40 - h, 6, h), const Radius.circular(3)), p);
  }
}

class TicketBooth extends PositionComponent {
  TicketBooth()
      : super(position: Vector2(900, 1200), size: Vector2(190, 150), anchor: Anchor.bottomCenter, priority: 1200);

  @override
  void render(Canvas c) {
    final p = Paint()..isAntiAlias = true;
    p.color = Colors.black26;
    c.drawOval(Rect.fromLTWH(10, 135, 170, 22), p);
    p.color = const Color(0xFFFFF3E0);
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(20, 60, 150, 88), const Radius.circular(8)), p);
    p.color = const Color(0xFF37474F);
    c.drawRect(const Rect.fromLTWH(45, 88, 100, 38), p);
    p.color = const Color(0xFF8D6E63);
    c.drawRect(const Rect.fromLTWH(38, 124, 114, 10), p);
    for (var i = 0; i < 6; i++) {
      p.color = i.isEven ? Colors.redAccent : Colors.white;
      c.drawRect(Rect.fromLTWH(i * (190 / 6), 40, 190 / 6, 30), p);
      c.drawCircle(Offset(i * (190 / 6) + 190 / 12, 70), 190 / 12, p);
    }
    p.color = const Color(0xFF7C4DFF);
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(30, 0, 130, 34), const Radius.circular(12)), p);
    drawText(c, tr('boothSign'), const Offset(95, 17), size: 20, center: true);
    drawText(c, '🎟', const Offset(95, 107), size: 24, center: true);
  }
}
