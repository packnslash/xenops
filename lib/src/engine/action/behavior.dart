import 'package:xenops/src/engine/unit/research.dart';

import 'action.dart';
import '../core/actor.dart';
import '../unit/city.dart';

abstract class Behavior {
  bool canPerform(Actor actor);
  Action getAction(Actor actor);
}

class ActionBehavior extends Behavior {
  final Action action;

  ActionBehavior(this.action);

  @override
  bool canPerform(Actor actor) => true;

  @override
  Action getAction(Actor actor) {
    actor.waitForInput();
    return action;
  }
}

class RestBehavior extends Behavior {
  @override
  bool canPerform(Actor actor) => true;

  @override
  Action getAction(Actor actor) {
    actor.waitForInput();
    return RestAction();
  }
}

class ResearchBehavior extends Behavior {
  final ResearchTopic topic;

  ResearchBehavior(this.topic);

  @override
  bool canPerform(Actor actor) {
    var city = actor as City;

    if (city.research.completed(topic) || !city.research.unlocked(topic)) {
      return false;
    }

    return true;
  }

  @override
  Action getAction(Actor actor) {
    actor.waitForInput();
    return ResearchAction(topic);
  }
}