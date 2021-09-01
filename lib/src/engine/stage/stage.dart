import 'package:piecemeal/piecemeal.dart';

import '../core/game.dart';
import '../core/actor.dart';
import 'tile.dart';

class Stage {
  final Game game;

  final _actors = <Actor>[];

  int _currentActorIndex = 0;

  int get width => tiles.width;
  int get height => tiles.height;
  
  Rect get bounds => tiles.bounds;

  Iterable<Actor> get actors => _actors;

  Actor get currentActor => _actors[_currentActorIndex];

  final Array2D<Tile> tiles;

  final Array2D<Actor?> _actorsByTile;

  Stage(int width, int height, this.game) : 
    tiles = Array2D.generated(width, height, (_) => Tile()),
    _actorsByTile = Array2D(width, height, null);

  Tile operator [](Vec pos) => tiles[pos];

  Tile get(int x, int y) => tiles.get(x,y);

  void set(int x, int y, Tile tile) => tiles.set(x, y, tile);

  void addActor(Actor actor) {
    assert(_actorsByTile[actor.pos] == null);

    _actors.add(actor);
    _actorsByTile[actor.pos] = actor;
  }

  void moveActor(Vec from, Vec to) {
    var actor = _actorsByTile[from];
    _actorsByTile[from] = null;
    _actorsByTile[to] = actor;
  }

  void removeActor(Actor actor) {
    assert(_actorsByTile[actor.pos] == actor);

    var index = _actors.indexOf(actor);
    if (_currentActorIndex > index) _currentActorIndex--;
    _actors.removeAt(index);

    if (_currentActorIndex >= _actors.length) _currentActorIndex = 0;

    _actorsByTile[actor.pos] = null;
  }

  void advanceActor() {
    _currentActorIndex = (_currentActorIndex + 1) % _actors.length;
  }

  void previousActor() {
    _currentActorIndex--;
    if (_currentActorIndex < 0) {
      _currentActorIndex += _actors.length;
    }
  }

  Actor? actorAt(Vec pos) => _actorsByTile[pos];

  void targetActor(Actor value) {
    _currentActorIndex = _actors.indexOf(value);
  }
}