
import 'package:piecemeal/piecemeal.dart';
import 'package:xenops/src/engine/unit/unitType.dart';
import '../core/game.dart';
import '../core/actor.dart';
import '../unit/research.dart';
import '../unit/city.dart';
import '../unit/unit.dart';

abstract class Action {
  Actor? _actor;
  Actor? get actor => _actor;

  late final Game _game;
  Game get game => _game;

  late final bool _consumesEnergy;
  bool get consumesEnergy => _consumesEnergy;

  void bind(Actor actor, {bool? consumesEnergy}) {
    _actor = actor;
    _game = actor.game;
    _consumesEnergy = consumesEnergy ?? true;
  }

  ActionResult perform() {
    return onPerform();
  }

  ActionResult onPerform();

  void log(String message) {
    _game.log.message(message);
  }

  void error(String message) {
    _game.log.error(message);
  }

  void gain(String message) {
    _game.log.help(message);
  }

  ActionResult succeed([String? message]) {
    if (message != null) log(message);
    return ActionResult.success;
  }

  ActionResult fail([String? message]) {
    if (message != null) error(message);
    return ActionResult.failure;
  }

  ActionResult alternate(Action action) {
    action.bind(_actor!);
    return ActionResult.alternate(action);
  }

  ActionResult doneIf(bool done) {
    return done ? ActionResult.success : ActionResult.notDone;
  }
}

class ActionResult {
  static const success = ActionResult(succeeded: true, done: true);
  static const failure = ActionResult(succeeded: false, done: true);
  static const notDone = ActionResult(succeeded: true, done: false);
  
  final Action? alternative;
  
  final bool succeeded;
  final bool done;

  const ActionResult({required this.succeeded, required this.done})
    : alternative = null;

  const ActionResult.alternate(this.alternative)
    : succeeded = false, done = true;
}

class RestAction extends Action {
  @override
  ActionResult onPerform() {
    return succeed('Rested');
  }
}

class ResearchAction extends Action {
  final ResearchTopic topic;

  ResearchAction(this.topic);

  @override
  ActionResult onPerform() {
    var city = actor as City;

    if (city.research.researchTopic(topic)) {
      city.lastBehavior = null;

      if (topic.result != UnitType.none) {
        game.stage.addActor(Unit(game, city.pos, topic.result));
      }

      return succeed('Research completed for ${topic.name}');
    }

    return succeed('Researched ${topic.name} (${city.research.progress(topic)} / ${topic.cost})');
  }
}