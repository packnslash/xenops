

class Energy {
  static const minSpeed = 0;
  static const normalSpeed = 6;
  static const maxSpeed = 12;

  static const actionCost = 240;

  static const gains = [
    15, // 1/4 normal speed
    20, // 1/3 normal speed
    24, // 2/5 normal speed
    30, // 1/2 normal speed
    40, // 2/3 normal speed
    50, // 5/6 normal speed
    60, // normal speed
    80, // 4/3 normal speed
    100, // 5/3 normal speed
    120, // 2x normal speed
    150, // 3/2 normal speed
    180, // 3x normal speed
    240 // 4x normal speed
  ];

  int energy = 0;

  bool get canTakeTurn => energy >= actionCost;

  bool gain(int speed) {
    energy += gains[speed];
    return canTakeTurn;
  }

  void spend() {
    assert(energy >= actionCost);
    energy -= actionCost;
  }
}