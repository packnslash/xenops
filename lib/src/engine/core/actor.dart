import 'package:piecemeal/piecemeal.dart';

import '../action/action.dart';
import '../action/behavior.dart';
import 'energy.dart';
import 'game.dart';

abstract class Actor {
  final String name;
  final Game game;
  final Energy energy = Energy();

  Vec get pos;

  Actor(this.name, this.game);

  Object get appearance;

  bool get needsInput {
    if (behavior != null && !behavior!.canPerform(this)) {
      waitForInput();
    }

    return behavior == null;
  }

  int get speed => 1;

  Behavior? behavior;
  Behavior? lastBehavior;

  Action getAction() {
    var action = onGetAction();
    action.bind(this);
    return action;
  }

  Action onGetAction() => behavior!.getAction(this);

  void continueBehavior() {
    behavior = lastBehavior;
    lastBehavior = null;
  }

  void waitForInput() {
    lastBehavior = behavior;
    behavior = null;
  } 

  void finishTurn(Action action) {
    energy.spend(action.energyCost);
    onFinishTurn(action);
  }

  void onFinishTurn(Action action) {
    // nothing
  }
}