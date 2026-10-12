import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Save extends ChangeNotifier {
  Save._();
  static final Save I = Save._();

  late SharedPreferences _p;

  String lang = 'fa';
  int character = 0;
  int outfit = 0;
  int coins = 100;
  bool music = true;
  bool sfx = true;
  bool dayTicket = false;
  Map<String, int> tickets = {};

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    lang = _p.getString('lang') ?? 'fa';
    character = _p.getInt('character') ?? 0;
    outfit = _p.getInt('outfit') ?? 0;
    coins = _p.getInt('coins') ?? 100;
    music = _p.getBool('music') ?? true;
    sfx = _p.getBool('sfx') ?? true;
    dayTicket = _p.getBool('dayTicket') ?? false;
    final raw = _p.getString('tickets');
    if (raw != null) {
      tickets = (jsonDecode(raw) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as int));
    }
  }

  Future<void> commit() async {
    await _p.setString('lang', lang);
    await _p.setInt('character', character);
    await _p.setInt('outfit', outfit);
    await _p.setInt('coins', coins);
    await _p.setBool('music', music);
    await _p.setBool('sfx', sfx);
    await _p.setBool('dayTicket', dayTicket);
    await _p.setString('tickets', jsonEncode(tickets));
    notifyListeners();
  }

  bool hasTicket(String ride) => dayTicket || (tickets[ride] ?? 0) > 0;

  bool buyTicket(String ride, int price) {
    if (coins < price) return false;
    coins -= price;
    tickets[ride] = (tickets[ride] ?? 0) + 1;
    commit();
    return true;
  }

  bool buyDayTicket(int price) {
    if (coins < price) return false;
    coins -= price;
    dayTicket = true;
    commit();
    return true;
  }

  bool useTicket(String ride) {
    if (dayTicket) return true;
    final n = tickets[ride] ?? 0;
    if (n <= 0) return false;
    tickets[ride] = n - 1;
    commit();
    return true;
  }

  void addCoins(int n) {
    coins += n;
    commit();
  }
}
