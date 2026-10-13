import 'package:flutter/material.dart';
import '../core/save.dart';

final Map<String, TextPainter> _cache = {};

TextPainter _tp(String t, double size, Color color, bool bold) {
  final key = '${Save.I.lang}|$t|$size|${color.hashCode}|$bold';
  if (_cache.length > 300) _cache.clear();
  return _cache.putIfAbsent(key, () {
    return TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          shadows: const [Shadow(color: Colors.black54, blurRadius: 3)],
        ),
      ),
      textDirection: Save.I.lang == 'fa' ? TextDirection.rtl : TextDirection.ltr,
    )..layout();
  });
}

double textWidth(String t, {double size = 16, bool bold = true}) =>
    _tp(t, size, Colors.white, bold).width;

void drawText(Canvas c, String t, Offset o,
    {double size = 16, Color color = Colors.white, bool bold = true, bool center = false}) {
  final tp = _tp(t, size, color, bold);
  tp.paint(c, center ? o - Offset(tp.width / 2, tp.height / 2) : o);
}
