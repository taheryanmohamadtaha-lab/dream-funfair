import 'save.dart';

const _s = <String, List<String>>{
  'title': ['شهربازی رؤیایی', 'Dream Funfair'],
  'version': ['نسخه', 'Version'],
  'producer': ['تولیدکننده', 'Developer'],
  'producerName': ['مجید طاهریان', 'Majid Taherian'],
  'start': ['شروع بازی', 'Start Game'],
  'character': ['انتخاب کاراکتر', 'Choose Character'],
  'settings': ['تنظیمات', 'Settings'],
  'about': ['درباره ما', 'About'],
  'music': ['موسیقی', 'Music'],
  'sfx': ['افکت صوتی', 'Sound Effects'],
  'language': ['زبان', 'Language'],
  'back': ['بازگشت', 'Back'],
  'select': ['انتخاب', 'Select'],
  'walk': ['راه رفتن', 'Walk'],
  'color': ['رنگ لباس', 'Outfit color'],
  'aboutText': [
    'یک بازی شهربازی کاملاً آفلاین با چرخ‌وفلک، ترن هوایی و کلی سرگرمی!',
    'A fully offline funfair game with a Ferris wheel, roller coaster and more!'
  ],
  'partTwo': [
    'دنیای شهربازی در بخش بعدی اضافه می‌شود.',
    'The park world comes in the next part.'
  ],
};

const charNames = <List<String>>[
  ['پسر', 'Boy'],
  ['دختر', 'Girl'],
  ['ربات', 'Robot'],
  ['گربه', 'Cat'],
  ['فضانورد', 'Astronaut'],
  ['دلقک', 'Clown'],
];

const appVersion = '1.0.0';

String tr(String k) => _s[k]![Save.I.lang == 'fa' ? 0 : 1];
String charName(int i) => charNames[i][Save.I.lang == 'fa' ? 0 : 1];
