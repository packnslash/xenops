import 'package:piecemeal/piecemeal.dart';

import '../action/action.dart';
import 'unit.dart';

abstract class Behavior {
  bool canPerform(Unit unit);
  Action getAction(Unit unit);
}

class ActionBehavior extends Behavior {
  final Action action;

  ActionBehavior(this.action);

  @override
  bool canPerform(Unit unit) => true;

  @override
  Action getAction(Unit unit) {
    unit.waitForInput();
    return action;
  }
}