class Energy {
  int energy = 0;

  bool get canTakeTurn => energy > 0;

  bool gain(int speed) {
    energy = speed;
    return canTakeTurn;
  }

  void spend(int cost) {
    assert(energy >= cost);
    energy -= cost;
  }
}