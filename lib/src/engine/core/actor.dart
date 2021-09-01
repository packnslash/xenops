import 'package:piecemeal/piecemeal.dart';

import '../action/action.dart';
import 'energy.dart';
import 'game.dart';

abstract class Actor {
  final Game game;
  final Energy energy = Energy();

  Vec _pos;
  Vec get pos => _pos;

  set pos(Vec value) {
    if (value != _pos) {
      changePosition(_pos, value);
      _pos = value;
    }
  }

  int get x => pos.x;

  set x(int value) {
    pos = Vec(value, y);
  }

  int get y => pos.y;

  set y(int value) {
    pos = Vec(x, value);
  }

  Actor(this.game, int x, int y) : _pos = Vec(x,y);

  Object get appearance;

  bool get needsInput => false;

  void changePosition(Vec from, Vec to) {
    game.stage.moveActor(from, to);
  }

  int speed = Energy.normalSpeed;

  Action getAction() {
    var action = onGetAction();
    action.bind(this);
    return action;
  }

  Action onGetAction();

  void finishTurn(Action action) {
    energy.spend();

    onFinishTurn(action);
  }

  void onFinishTurn(Action action) {
    // nothing
  }
}