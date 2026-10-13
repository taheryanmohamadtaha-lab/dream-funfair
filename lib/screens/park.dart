import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/park_game.dart';
import '../widgets/shop_overlay.dart';

class ParkScreen extends StatefulWidget {
  const ParkScreen({super.key});
  @override
  State<ParkScreen> createState() => _ParkScreenState();
}

class _ParkScreenState extends State<ParkScreen> {
  late final ParkGame game = ParkGame(onExit: () => Navigator.of(context).pop());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<ParkGame>(
        game: game,
        overlayBuilderMap: {
          'shop': (ctx, g) => ShopOverlay(onClose: g.closeShop),
        },
      ),
    );
  }
}
