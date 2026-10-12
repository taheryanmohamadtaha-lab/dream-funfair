import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../widgets/fun_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: funGradient,
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: 460,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎡🎢🎠', style: TextStyle(fontSize: 36)),
                      Text(tr('title'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text('${tr('version')}: $appVersion', style: const TextStyle(fontSize: 17)),
                      Text('${tr('producer')}: ${tr('producerName')}', style: const TextStyle(fontSize: 17)),
                      const SizedBox(height: 8),
                      Text(tr('aboutText'), textAlign: TextAlign.center),
                      FunButton(
                        label: tr('back'),
                        color: Colors.deepPurple,
                        width: 160,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
