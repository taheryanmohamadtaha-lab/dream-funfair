import 'package:flutter/material.dart';
import '../core/save.dart';
import '../core/strings.dart';
import '../widgets/character_painter.dart';
import '../widgets/fun_button.dart';
import 'about.dart';
import 'character_select.dart';
import 'park.dart';
import 'settings.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _go(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: funGradient,
        child: SafeArea(
          child: ListenableBuilder(
            listenable: Save.I,
            builder: (_, __) => Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🎡', style: TextStyle(fontSize: 44)),
                          Text(tr('title'),
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))],
                              )),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 130,
                            width: 100,
                            child: AnimatedBuilder(
                              animation: _c,
                              builder: (_, __) => CustomPaint(
                                painter: CharacterPainter(Save.I.character,
                                    outfitColors[Save.I.outfit], _c.value, true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FunButton(label: tr('start'), color: Colors.green, icon: Icons.play_arrow, onTap: () => _go(const ParkScreen())),
                          FunButton(label: tr('character'), color: Colors.blue, icon: Icons.face, onTap: () => _go(const CharacterSelectScreen())),
                          FunButton(label: tr('settings'), color: Colors.orange, icon: Icons.settings, onTap: () => _go(const SettingsScreen())),
                          FunButton(label: tr('about'), color: Colors.purple, icon: Icons.info, onTap: () => _go(const AboutScreen())),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 6,
                  left: 12,
                  right: 12,
                  child: Text(
                    '${tr('version')} $appVersion  •  ${tr('producer')}: ${tr('producerName')}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 12,
                  child: Chip(
                    avatar: const Text('🪙'),
                    label: Text('${Save.I.coins}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
