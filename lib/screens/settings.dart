import 'package:flutter/material.dart';
import '../core/save.dart';
import '../core/strings.dart';
import '../widgets/fun_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: funGradient,
        child: SafeArea(
          child: ListenableBuilder(
            listenable: Save.I,
            builder: (_, __) => Center(
              child: SizedBox(
                width: 420,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(tr('settings'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SwitchListTile(
                          title: Text(tr('music')),
                          value: Save.I.music,
                          onChanged: (v) {
                            Save.I.music = v;
                            Save.I.commit();
                          },
                        ),
                        SwitchListTile(
                          title: Text(tr('sfx')),
                          value: Save.I.sfx,
                          onChanged: (v) {
                            Save.I.sfx = v;
                            Save.I.commit();
                          },
                        ),
                        ListTile(
                          title: Text(tr('language')),
                          trailing: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'fa', label: Text('فارسی')),
                              ButtonSegment(value: 'en', label: Text('English')),
                            ],
                            selected: {Save.I.lang},
                            onSelectionChanged: (s) {
                              Save.I.lang = s.first;
                              Save.I.commit();
                            },
                          ),
                        ),
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
      ),
    );
  }
}
