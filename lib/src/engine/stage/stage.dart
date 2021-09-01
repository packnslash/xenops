import 'package:piecemeal/piecemeal.dart';

import '../core/game.dart';
import '../core/actor.dart';
import '../unit/unit.dart';
import '../unit/city.dart';
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

  final Array2D<Unit?> _unitsByTile;
  final Array2D<City?> _citiesByTile;

  Stage(int width, int height, this.game) : 
    tiles = Array2D.generated(width, height, (_) => Tile()),
    _unitsByTile = Array2D(width, height, null),
    _citiesByTile = Array2D(width, height, null);

  Tile operator [](Vec pos) => tiles[pos];

  Tile get(int x, int y) => tiles.get(x,y);

  void set(int x, int y, Tile tile) => tiles.set(x, y, tile);

  void addActor(Actor actor) {
    if (actor is Unit) {
      assert(_unitsByTile[actor.pos] == null);

      _unitsByTile[actor.pos] = actor;
    } else if (actor is City) {
      assert(_citiesByTile[actor.pos] == null);

      _citiesByTile[actor.pos] = actor;
    }
    
    _actors.add(actor);
  }

  void moveUnit(Vec from, Vec to) {
    var actor = _unitsByTile[from];
    _unitsByTile[from] = null;
    _unitsByTile[to] = actor;
  }

  void removeUnit(Unit unit) {
    assert(_unitsByTile[unit.pos] == unit);

    var index = _actors.indexOf(unit);
    if (_currentActorIndex > index) _currentActorIndex--;
    _actors.removeAt(index);

    if (_currentActorIndex >= _actors.length) _currentActorIndex = 0;

    _unitsByTile[unit.pos] = null;
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

  Actor? actorAt(Vec pos) {
    if (_unitsByTile[pos] != null) {
      return _unitsByTile[pos];
    } 
    else {
      return _citiesByTile[pos];
    }
  }

  Unit? unitAt(Vec pos) => _unitsByTile[pos];
  
  City? cityAt(Vec pos) => _citiesByTile[pos];

  void targetActor(Actor value) {
    _currentActorIndex = _actors.indexOf(value);
  }
}