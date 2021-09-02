import 'dart:collection';

import 'package:piecemeal/piecemeal.dart';

import '../action/action.dart';
import '../stage/stage.dart';
import '../unit/city.dart';
import '../unit/research.dart';
import 'log.dart';

class Game {
  final Content content;
  final Research _research;

  final log = Log();

  final _actions = Queue<Action>();

  Stage get stage => _stage;
  late Stage _stage;

  Game(this.content, {int? width, int? height}) : _research = Research() {
    _stage = Stage(width ?? 80, height ?? 80, this);
  }

  void buildStage() {
    var cityPos;

    content.buildStage(_research, _stage, (pos) { 
      cityPos = pos;
    });

    _research.unlockTier(0);

    var city = City(this, cityPos, _research);
    _stage.addActor(city);
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

            if (!action.actor!.energy.canTakeTurn) {
              stage.advanceActor();
            }
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

abstract class Content {
  void buildStage(Research research, Stage stage, Function(Vec) placeCity);

  Iterable<ResearchTopic> get researchTopics;
}