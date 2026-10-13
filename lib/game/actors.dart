import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../core/save.dart';
import '../core/strings.dart';
import '../widgets/character_painter.dart';
import 'park_game.dart';
import 'world_consts.dart';

class Player extends PositionComponent with HasGameReference<ParkGame> {
  Player()
      : super(position: Vector2(1200, 1580), size: Vector2(56, 84), anchor: Anchor.bottomCenter);

  Vector2? target;
  bool walking = false;
  bool hidden = false;
  double t = 0;
  static const double speed = 170;

  @override
  void update(double dt) {
    priority = position.y.toInt();
    if (game.riding || hidden) return;

    Vector2 dir = Vector2.zero();
    if (game.intro) {
      dir = Vector2(0, -0.8);
      if (position.y <= 1385) game.finishIntro();
    } else {
      final j = game.joystick.relativeDelta;
      if (j.length2 > 0.0004) {
        dir = j.clone();
        target = null;
      } else if (target != null) {
        final to = target! - position;
        if (to.length < 6) {
          target = null;
        } else {
          dir = to.normalized();
        }
      }
    }

    walking = dir.length2 > 0.0001;
    if (walking) {
      position.add(dir * (speed * dt));
      t = (t + dt / 1.2) % 1;
      if (!game.intro) {
        position.x = position.x.clamp(60.0, worldW - 60).toDouble();
        position.y = position.y.clamp(80.0, gateY - 40).toDouble();
      }
    }
  }

  @override
  void render(Canvas c) {
    if (hidden) return;
    CharacterPainter(Save.I.character, outfitColors[Save.I.outfit], t, walking)
        .paint(c, Size(size.x, size.y));
  }
}

/// Background crowd.
class Npc extends PositionComponent with HasGameReference<ParkGame> {
  final int type;
  final Color color;
  final math.Random rnd;
  late Vector2 target;
  late double speed;
  double t = 0;

  Npc(this.type, this.color, Vector2 pos, this.rnd)
      : super(position: pos, size: Vector2(44, 66), anchor: Anchor.bottomCenter) {
    target = pos.clone();
    speed = 35 + rnd.nextDouble() * 30;
    t = rnd.nextDouble();
  }

  @override
  void update(double dt) {
    priority = position.y.toInt();
    final to = target - position;
    if (to.length < 8) {
      target = Vector2(200 + rnd.nextDouble() * 2000, 300 + rnd.nextDouble() * 1080);
    } else {
      position.add(to.normalized() * (speed * dt));
      t = (t + dt / 1.3) % 1;
    }
  }

  @override
  void render(Canvas c) {
    CharacterPainter(type, color, t, true).paint(c, Size(size.x, size.y));
  }
}

class CoinPickup extends PositionComponent with HasGameReference<ParkGame> {
  double t = 0;
  CoinPickup(Vector2 pos)
      : super(position: pos, size: Vector2.all(28), anchor: Anchor.center);

  @override
  void update(double dt) {
    t += dt;
    priority = position.y.toInt() - 1;
    if (!game.player.hidden && game.player.position.distanceTo(position) < 45) {
      Save.I.addCoins(5);
      game.toast('+5 🪙');
      removeFromParent();
      game.respawnCoinLater();
    }
  }

  @override
  void render(Canvas c) {
    final w = size.x * (math.cos(t * 4).abs() * 0.8 + 0.2);
    final p = Paint()..isAntiAlias = true;
    final r = Rect.fromCenter(center: Offset(size.x / 2, size.y / 2 - 4 * math.sin(t * 3)), width: w, height: size.y);
    p.color = const Color(0xFFFFB300);
    c.drawOval(r, p);
    p.color = const Color(0xFFFFE082);
    c.drawOval(r.deflate(4), p);
  }
}
