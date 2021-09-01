

import 'package:piecemeal/piecemeal.dart';
import 'package:xenops/src/engine/core/energy.dart';

import '../action/action.dart';
import '../core/actor.dart';
import '../core/game.dart';
import 'behavior.dart';

class Unit extends Actor {
  Behavior? _behavior;

  Unit(Game game, Vec pos) : super(game, pos.x, pos.y) {
    energy.energy = Energy.actionCost;
  }

  @override
  Object get appearance => 'unit';

  @override
  bool get needsInput {
    if (_behavior != null && !_behavior!.canPerform(this)) {
      waitForInput();
    }

    return _behavior == null;
  }

  @override
  Action onGetAction() => _behavior!.getAction(this);

  void setNextAction(Action action) {
    _behavior = ActionBehavior(action);
  }

  void waitForInput() {
    _behavior = null;
  }  
}