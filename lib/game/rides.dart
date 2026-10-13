class RideInfo {
  final String id;
  final List<String> name; // [fa, en]
  final int price;
  final bool ready; // implemented in the game yet?
  const RideInfo(this.id, this.name, this.price, this.ready);
}

const dayPassPrice = 60;

const rides = <RideInfo>[
  RideInfo('ferris', ['چرخ‌وفلک بزرگ', 'Big Ferris Wheel'], 10, true),
  RideInfo('coaster', ['ترن هوایی', 'Roller Coaster'], 15, false),
  RideInfo('carousel', ['کارروسل', 'Carousel'], 8, false),
  RideInfo('boat', ['قایق‌سواری', 'Boat Ride'], 8, false),
  RideInfo('bumper', ['ماشین برخوردی', 'Bumper Cars'], 10, false),
  RideInfo('haunted', ['خانه ترسناک', 'Haunted House'], 12, false),
];
