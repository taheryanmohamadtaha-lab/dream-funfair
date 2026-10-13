import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../core/save.dart';
import '../core/strings.dart';
import '../widgets/character_painter.dart';
import 'actors.dart';
import 'ferris_wheel.dart';
import 'hud.dart';
import 'park_map.dart';
import 'world_consts.dart';

class Spot {
  final Vector2 pos;
  final double radius;
  final String Function() label;
  final VoidCallback action;
  Spot(this.pos, this.radius, this.label, this.action);
}

class ParkGame extends FlameGame {
  ParkGame({required this.onExit});
  final VoidCallback onExit;

  late final JoystickComponent joystick;
  late final Player player;
  late final FerrisWheel wheel;

  final List<Spot> spots = [];
  final math.Random rnd = math.Random();

  double clock = dayLength * 0.05;
  double dark = 0;
  double happiness = 50;
  double energy = 100;
  bool riding = false;
  bool intro = true;
  double rideT = 0;
  double zoomTarget = 1;
  String toastText = '';
  double toastT = 0;
  Spot? nearSpot;

  double get tintDark => riding ? 0.45 : dark;
  String? get interactLabel => riding ? tr('endRide') : nearSpot?.label();
  bool get shopOpen => overlays.isActive('shop');

  @override
  Color backgroundColor() => const Color(0xFF4C9A3A);

  @override
  Future<void> onLoad() async {
    world.add(ParkMap());
    world.add(LampPosts());
    world.add(Fountain());
    world.add(TicketBooth());
    wheel = FerrisWheel();
    world.add(wheel);

    for (var i = 0; i < 14; i++) {
      world.add(Npc(
        rnd.nextInt(6),
        outfitColors[rnd.nextInt(6)],
        Vector2(300 + rnd.nextDouble() * 1800, 300 + rnd.nextDouble() * 1000),
        rnd,
      ));
    }
    for (var i = 0; i < 18; i++) {
      spawnCoin();
    }

    player = Player();
    world.add(player);
    world.add(TapLayer());

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 24, paint: Paint()..color = const Color(0xDDFFFFFF)),
      background: CircleComponent(radius: 56, paint: Paint()..color = const Color(0x55000000)),
      margin: const EdgeInsets.only(left: 40, bottom: 36),
    );

    camera.viewport.add(Tint());
    camera.viewport.add(joystick);
    camera.viewport.add(Hud());
    camera.viewport.add(HudButton(
      label: () => interactLabel ?? '',
      visible: () => !shopOpen && (riding || (nearSpot != null && !intro)),
      onTap: interact,
      color: const Color(0xFF00C853),
      place: (s) => Vector2(s.x - 125, s.y - 56),
      size: Vector2(220, 56),
    ));
    camera.viewport.add(HudButton(
      label: () => '✕',
      visible: () => !riding && !shopOpen,
      onTap: onExit,
      color: const Color(0xFFE53935),
      place: (s) => Vector2(s.x - 34, 34),
      size: Vector2(48, 48),
    ));

    spots.add(Spot(Vector2(900, 1235), 130, () => tr('boothLabel'), openShop));
    spots.add(Spot(Vector2(1750, 720), 140, () => tr('rideFerris'), tryFerris));

    camera.follow(player, snap: true);
  }

  // ---------- helpers ----------
  void toast(String s) {
    toastText = s;
    toastT = 2.6;
  }

  void finishIntro() {
    intro = false;
    toast(tr('welcome'));
  }

  void spawnCoin() {
    final onVertical = rnd.nextBool();
    final pos = onVertical
        ? Vector2(1100 + rnd.nextDouble() * 200, 300 + rnd.nextDouble() * 1050)
        : Vector2(200 + rnd.nextDouble() * 2000, 740 + rnd.nextDouble() * 120);
    world.add(CoinPickup(pos));
  }

  void respawnCoinLater() {
    add(TimerComponent(period: 7, removeOnFinish: true, onTick: spawnCoin));
  }

  void interact() {
    if (riding) {
      endRide();
      return;
    }
    nearSpot?.action();
  }

  void openShop() {
    overlays.add('shop');
    pauseEngine();
  }

  void closeShop() {
    overlays.remove('shop');
    resumeEngine();
  }

  // ---------- Ferris wheel ----------
  void tryFerris() {
    if (!Save.I.useTicket('ferris')) {
      toast(tr('noTicket'));
      return;
    }
    riding = true;
    rideT = 0;
    player.hidden = true;
    player.target = null;
    camera.stop();
    zoomTarget = 0.55;
    wheel.speed = 0.22;
    toast(tr('boarding'));
  }

  void endRide() {
    riding = false;
    player.hidden = false;
    wheel.speed = 0.12;
    zoomTarget = 1;
    camera.follow(player, maxSpeed: 800);
    happiness = math.min(100, happiness + 25);
    energy = math.max(0, energy - 10);
    toast(tr('enjoy'));
  }

  @override
  void update(double dt) {
    super.update(dt);
    clock += dt;
    final phase = (clock / dayLength) % 1.0;
    dark = (1 - math.cos(2 * math.pi * phase)) / 2;
    if (toastT > 0) toastT -= dt;

    nearSpot = null;
    if (!riding && !intro) {
      var best = 1e9;
      for (final s in spots) {
        final d = s.pos.distanceTo(player.position);
        if (d < s.radius && d < best) {
          best = d;
          nearSpot = s;
        }
      }
    }

    if (riding) {
      rideT += dt;
      camera.viewfinder.position = wheel.cabinPos(0);
      if (rideT > 22) endRide();
    }
    final z = camera.viewfinder.zoom;
    camera.viewfinder.zoom = z + (zoomTarget - z) * math.min(1.0, dt * 1.5);
  }
}
