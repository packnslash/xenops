import 'dart:collection';

import 'package:piecemeal/piecemeal.dart';
import 'package:xenops/src/engine/unit/unit.dart';

import 'energy.dart';
import 'log.dart';
import '../stage/stage.dart';
import '../action/action.dart';

import '../../content/stage/map.dart';

class Game {
  final log = Log();

  final _actions = Queue<Action>();

  Stage get stage => _stage;
  late Stage _stage;

  Game({int? width, int? height}) {
    _stage = Stage(width ?? 80, height ?? 80, this);
  }

  void buildStage() {
    var unitPos;

    World(stage).buildStage((pos) { 
      unitPos = pos;
    });

    var unit = Unit(this, unitPos);
    _stage.addActor(unit);

    var nextUnit = Unit(this, Vec(unitPos.x + 5, unitPos.y));
    nextUnit.speed = Energy.minSpeed;
    _stage.addActor(nextUnit);
  }

  GameResult update() {
    var madeProgress = false;

    while (true) {
      while (_actions.isNotEmpty) {
        var action = _actions.first;

        var result = action.perform();

        while (result.alternative != null) {
          _actions.removeFirst();
          action = result.alternative!;
          _actions.addFirst(action);

          result = action.perform();
        }

        madeProgress = true;

        if (result.done) {
          _actions.removeFirst();

          if (result.succeeded && action.consumesEnergy) {
            action.actor!.finishTurn(action);
            stage.advanceActor();
          }
        }
      }

      while (_actions.isEmpty) {
        var actor = stage.currentActor;

        if (actor.energy.canTakeTurn && actor.needsInput) {
          return makeResult(madeProgress);
        }

        if (actor.energy.canTakeTurn || actor.energy.gain(actor.speed)) {
          if (actor.needsInput) return makeResult(madeProgress);

          _actions.add(actor.getAction());
        } else {
          stage.advanceActor();
        }
      }
    }
  }

  void addAction(Action action) {
    _actions.add(action);
  }

  GameResult makeResult(bool madeProgress) {
    var result = GameResult(madeProgress);
    return result;
  }
}

class GameResult {
  final bool madeProgress;

  bool get needsRefresh => madeProgress;

  GameResult(this.madeProgress);
}