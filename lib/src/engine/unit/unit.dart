import 'package:piecemeal/piecemeal.dart';
import '../action/action.dart';
import '../core/actor.dart';
import '../core/game.dart';
import '../action/behavior.dart';
import 'unitType.dart';

class Unit extends Actor {
  final UnitType type;

  Vec _pos;

  @override
  Vec get pos => _pos;
  
  int get x => pos.x;
  int get y => pos.y;

  set pos(Vec value) {
    if (this is Unit) {
      if (value != _pos) {
        changePosition(_pos, value);
        _pos = value;
      }
    }
  }

  set x(int value) {
    pos = Vec(value, y);
  }

  set y(int value) {
    pos = Vec(x, value);
  }

  @override
  int get speed => 2;

  Unit(Game game, this._pos, this.type) : super('Unit', game) {
    energy.energy = speed;
  }

  @override
  Object get appearance => 'unit';

  void setNextAction(Action action) {
    behavior = ActionBehavior(action);
  }

  void changePosition(Vec from, Vec to) {
    game.stage.moveUnit(from, to);
  }
}