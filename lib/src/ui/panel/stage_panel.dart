import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

import '../../engine/unit/city.dart';
import '../../hues.dart';
import '../game_screen.dart';
import 'panel.dart';

class StagePanel extends Panel {
  final GameScreen _gameScreen;

  StagePanel(this._gameScreen);

  Rect get cameraBounds => _cameraBounds;

  late Rect _cameraBounds;
  late Vec _renderOffset;

  void _drawStageGlyph(Terminal terminal, int x, int y, Glyph glyph) {
    terminal.drawGlyph(x - _cameraBounds.x + _renderOffset.x, y - _cameraBounds.y + _renderOffset.y, glyph);
  }

  @override
  void renderPanel(Terminal terminal) {
    _positionCamera(terminal.size);

    var game = _gameScreen.game;

    for (var pos in _cameraBounds) {
      int char;
      var fore = Color.black;
      var back = Color.black;

      var tile = game.stage[pos];
      var tileGlyph = tile.type.appearance as Glyph;

      char = tileGlyph.char;
      fore = tileGlyph.fore;
      back = tileGlyph.back;

      var actor = game.stage.actorAt(pos);

      if (game.stage.currentActor is City) {
        var city = game.stage.currentActor as City;
        if (city.claimedTiles.contains(pos)) {
          fore = Color.gold;
          back = Color.darkGold;
        } else if (city.claimableTiles.contains(pos)) {
          fore = Color.purple;
          back = Color.darkPurple;
        }
      }

      if (actor != null) {
        var actorGlyph = actor.appearance;
        if (actorGlyph is Glyph) {
          char = actorGlyph.char;
          fore = actorGlyph.fore;
        } else {
          char = CharCode.at;
          fore = ash;
        }
      }

      var glyph = Glyph.fromCharCode(char, fore, back);
      _drawStageGlyph(terminal, pos.x, pos.y, glyph);
    }
  }

  void _positionCamera(Vec size) {
    var game = _gameScreen.game;

    var rangeWidth = math.max(0, game.stage.width - size.x);
    var rangeHeight = math.max(0, game.stage.height - size.y);

    var cameraRange = Rect(0, 0, rangeWidth, rangeHeight);

    var camera = game.stage.currentActor.pos - size ~/ 2;
    camera = cameraRange.clamp(camera);

    _cameraBounds = Rect(camera.x, camera.y, math.min(size.x, game.stage.width), math.min(size.y, game.stage.height));

    _renderOffset = Vec(math.max(0, size.x - game.stage.width) ~/ 2, math.max(0, size.y - game.stage.height) ~/2);
  }
}