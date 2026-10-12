import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../widgets/fun_button.dart';

/// Placeholder: replaced in part 2 by the Flame-based park world.
class ParkScreen extends StatelessWidget {
  const ParkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: funGradient,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr('partTwo'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
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
    );
  }
}
