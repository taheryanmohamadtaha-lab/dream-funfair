import 'package:flutter/material.dart';
import '../core/save.dart';
import '../core/strings.dart';
import '../game/rides.dart';

class ShopOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const ShopOverlay({super.key, required this.onClose});
  @override
  State<ShopOverlay> createState() => _ShopOverlayState();
}

class _ShopOverlayState extends State<ShopOverlay> {
  String msg = '';

  void _buy(RideInfo r) {
    final ok = Save.I.buyTicket(r.id, r.price);
    setState(() => msg = ok ? tr('bought') : tr('noCoins'));
  }

  void _buyDay() {
    final ok = Save.I.buyDayTicket(dayPassPrice);
    setState(() => msg = ok ? tr('bought') : tr('noCoins'));
  }

  @override
  Widget build(BuildContext context) {
    final fa = Save.I.lang == 'fa';
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 460,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF7C4DFF), width: 4),
          ),
          child: ListenableBuilder(
            listenable: Save.I,
            builder: (_, __) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('🎟 ${tr('boothLabel')}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      Chip(avatar: const Text('🪙'), label: Text('${Save.I.coins}')),
                    ],
                  ),
                  for (final r in rides.where((r) => r.ready))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(r.name[fa ? 0 : 1], style: const TextStyle(fontSize: 16))),
                          Text('🎟 ${Save.I.tickets[r.id] ?? 0}'),
                          const SizedBox(width: 10),
                          FilledButton(onPressed: () => _buy(r), child: Text('${r.price} 🪙')),
                        ],
                      ),
                    ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(Save.I.dayTicket ? tr('dayTicketOwned') : tr('dayTicket'),
                            style: const TextStyle(fontSize: 16)),
                      ),
                      if (!Save.I.dayTicket)
                        FilledButton(onPressed: _buyDay, child: Text('$dayPassPrice 🪙')),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(msg, style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  FilledButton.tonal(onPressed: widget.onClose, child: Text(tr('close'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
