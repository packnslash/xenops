import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:xenops/src/content/research/topics.dart';
import 'package:xenops/src/engine/action/behavior.dart';

import '../core/actor.dart';
import '../core/energy.dart';
import '../core/game.dart';
import 'research.dart';

class City extends Actor {
  final Research research;

  final Vec _pos;

  @override
  Vec get pos => _pos;

  City(Game game, this._pos, this.research) : super('City', game) {
    energy.energy = Energy.actionCost;
  }
  
  @override
  Object get appearance => Glyph('C');

  void setNextResearch(ResearchTopic topic) {
    lastBehavior = null;
    behavior = ResearchBehavior(topic);
  }
}