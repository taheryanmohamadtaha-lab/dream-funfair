import 'package:flutter/material.dart';
import '../core/save.dart';
import '../core/strings.dart';
import '../widgets/character_painter.dart';
import '../widgets/fun_button.dart';

class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});
  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  int _char = Save.I.character;
  int _outfit = Save.I.outfit;
  bool _walking = true;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: funGradient,
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.95,
                    children: [
                      for (var i = 0; i < 6; i++)
                        GestureDetector(
                          onTap: () => setState(() => _char = i),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(_char == i ? 235 : 130),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: _char == i ? Colors.yellowAccent : Colors.white, width: 3),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: AnimatedBuilder(
                                      animation: _c,
                                      builder: (_, __) => CustomPaint(
                                        size: Size.infinite,
                                        painter: CharacterPainter(i, outfitColors[_outfit], _c.value, _char == i && _walking),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(charName(i), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 120,
                      child: AnimatedBuilder(
                        animation: _c,
                        builder: (_, __) => CustomPaint(
                          painter: CharacterPainter(_char, outfitColors[_outfit], _c.value, _walking),
                        ),
                      ),
                    ),
                    Text(tr('color'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var i = 0; i < outfitColors.length; i++)
                          GestureDetector(
                            onTap: () => setState(() => _outfit = i),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: outfitColors[i],
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: _outfit == i ? Colors.white : Colors.black26, width: 3),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    FunButton(
                      label: tr('walk'),
                      color: Colors.teal,
                      width: 150,
                      onTap: () => setState(() => _walking = !_walking),
                    ),
                    FunButton(
                      label: tr('select'),
                      color: Colors.green,
                      width: 150,
                      onTap: () async {
                        Save.I.character = _char;
                        Save.I.outfit = _outfit;
                        await Save.I.commit();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                    FunButton(
                      label: tr('back'),
                      color: Colors.deepPurple,
                      width: 150,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
