import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:xenops/src/engine/action/behavior.dart';

import '../action/action.dart';
import '../core/actor.dart';
import '../core/game.dart';
import 'research.dart';

class City extends Actor {
  final Research research;

  final Vec _pos;
  final claimedTiles = <Vec>[];
  final claimableTiles = <Vec>[];

  final int claimTurns = 6;
  late int claimTurnCounter;

  @override
  Vec get pos => _pos;

  City(Game game, this._pos, this.research) : super('City', game) {
    energy.energy = speed;

    claimedTiles.add(pos);
    claimedTiles.addAll(pos.neighbors);
    claimTurnCounter = claimTurns;

    updateClaimableTiles();
  }
  
  @override
  Object get appearance => Glyph('C');

  void setNextResearch(ResearchTopic topic) {
    // handle the resetting of Unit Research progress
    if (lastBehavior != null && lastBehavior is ResearchBehavior) {
      var lb = lastBehavior as ResearchBehavior;

      if (lb.topic.oneOff) {
        research.resetTopic(lb.topic);
      }
    }

    lastBehavior = null;
    behavior = ResearchBehavior(topic);
  }

  void updateClaimableTiles() {
    for (var claimed in claimedTiles) {
      for (var neighbor in claimed.cardinalNeighbors) {
        if (claimedTiles.contains(neighbor)) continue;
        if (claimableTiles.contains(neighbor)) continue;

        claimableTiles.add(neighbor);
      }
    }
  }

  void claimTile() {
    var candidate = rng.item(claimableTiles);

    claimableTiles.remove(candidate);
    claimedTiles.add(candidate);

    for (var neighbor in candidate.cardinalNeighbors) {
      if (claimedTiles.contains(neighbor)) continue;
      if (claimableTiles.contains(neighbor)) continue;

      claimableTiles.add(neighbor);
    }
  }

  @override
  void onFinishTurn(Action action) {
    claimTurnCounter--;
    if (claimTurnCounter == 0) {
      claimTurnCounter = claimTurns;
      claimTile();
    }
  }
}