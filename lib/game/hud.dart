import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../core/save.dart';
import '../core/strings.dart';
import 'draw_util.dart';
import 'park_game.dart';
import 'world_consts.dart';

Color tintColor(double d) {
  if (d < 0.5) {
    return Color.lerp(const Color(0x00FF9800), const Color(0x59FF7043), d * 2)!;
  }
  return Color.lerp(const Color(0x59FF7043), const Color(0xA00D1B4A), (d - 0.5) * 2)!;
}

/// Full-screen day/night colour overlay.
class Tint extends Component with HasGameReference<ParkGame> {
  Tint() : super(priority: -1);
  final Paint _p = Paint();

  @override
  void render(Canvas c) {
    _p.color = tintColor(game.tintDark);
    c.drawRect(Rect.fromLTWH(0, 0, game.size.x, game.size.y), _p);
  }
}

class Hud extends Component with HasGameReference<ParkGame> {
  Hud() : super(priority: 10);

  void _chip(Canvas c, double x, double y, double w, String text) {
    final p = Paint()..color = Colors.black.withAlpha(130);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, 32), const Radius.circular(16)), p);
    drawText(c, text, Offset(x + 10, y + 5), size: 17);
  }

  void _bar(Canvas c, double x, double y, String label, double v, Color col) {
    drawText(c, label, Offset(x, y), size: 12);
    final p = Paint()..color = Colors.white30;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y + 16, 120, 9), const Radius.circular(5)), p);
    p.color = col;
    c.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y + 16, 120 * (v / 100).clamp(0.0, 1.0), 9), const Radius.circular(5)), p);
  }

  @override
  void render(Canvas c) {
    final s = Save.I;
    _chip(c, 10, 8, 118, '🪙 ${s.coins}');
    final count = s.tickets.values.fold<int>(0, (a, b) => a + b);
    _chip(c, 134, 8, 92, '🎟 ${s.dayTicket ? '∞' : count}');
    _bar(c, 12, 48, tr('happy'), game.happiness, Colors.pinkAccent);
    _bar(c, 12, 76, tr('energy'), game.energy, Colors.lightGreenAccent);

    if (game.toastT > 0) {
      final w = textWidth(game.toastText, size: 17) + 36;
      final x = (game.size.x - w) / 2;
      final p = Paint()..color = Colors.black.withAlpha(170);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, 12, w, 38), const Radius.circular(19)), p);
      drawText(c, game.toastText, Offset(game.size.x / 2, 31), size: 17, center: true);
    }
  }
}

class HudButton extends PositionComponent with TapCallbacks, HasGameReference<ParkGame> {
  final String Function() label;
  final bool Function() visible;
  final VoidCallback onTap;
  final Color color;
  final Vector2 Function(Vector2) place;

  HudButton({
    required this.label,
    required this.visible,
    required this.onTap,
    required this.color,
    required this.place,
    required Vector2 size,
  }) : super(size: size, anchor: Anchor.center, priority: 20);

  @override
  void update(double dt) {
    position = place(game.size);
  }

  @override
  void render(Canvas c) {
    if (!visible()) return;
    final r = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    c.drawRRect(r.shift(const Offset(0, 3)), Paint()..color = Colors.black38);
    c.drawRRect(r, Paint()..color = color);
    c.drawRRect(r, Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3);
    drawText(c, label(), Offset(size.x / 2, size.y / 2), size: 17, center: true);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (visible()) onTap();
  }
}

/// Tap on the ground to walk there.
class TapLayer extends PositionComponent with TapCallbacks, HasGameReference<ParkGame> {
  TapLayer() : super(position: Vector2.zero(), size: Vector2(worldW, worldH), priority: -99999);

  @override
  void onTapUp(TapUpEvent event) {
    if (game.riding || game.intro) return;
    final cp = event.canvasPosition;
    if (cp.x < 220 && cp.y > game.size.y - 220) return; // joystick area
    final p = event.localPosition;
    game.player.target = Vector2(
      p.x.clamp(60.0, worldW - 60).toDouble(),
      p.y.clamp(80.0, gateY - 40).toDouble(),
    );
  }
}
