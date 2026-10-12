import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../widgets/fun_button.dart';
import 'menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MenuScreen(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
      ));
    });
  }

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
        child: Center(
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              final s = Curves.elasticOut.transform(_c.value);
              return Opacity(
                opacity: _c.value.clamp(0.0, 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: s,
                      child: const Text('🎡🎢🎠', style: TextStyle(fontSize: 54)),
                    ),
                    Transform.scale(
                      scale: s,
                      child: Text(tr('title'),
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))],
                          )),
                    ),
                    const SizedBox(height: 10),
                    Text('${tr('version')} $appVersion  •  ${tr('producer')}: ${tr('producerName')}',
                        style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
