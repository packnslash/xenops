import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:xenops/src/engine/action/action.dart';

import '../engine/core/game.dart';
import '../engine/core/actor.dart';
import '../engine/unit/unit.dart';

import 'input.dart';
import 'panel/log_panel.dart';
import 'panel/sidebar_panel.dart';
import 'panel/stage_panel.dart';

class GameScreen extends Screen<Input> {
  final Game game;

  final LogPanel _logPanel;
  late final SidebarPanel _sidebarPanel;
  late final StagePanel _stagePanel;

  GameScreen(this.game) : _logPanel = LogPanel(game.log), _sidebarPanel = SidebarPanel() {
    _stagePanel = StagePanel(this);
  }

  factory GameScreen.town() {
    var game = Game(width: 93, height: 93);
    game.buildStage();

    return GameScreen(game);
  }

  @override
  bool handleInput(Input input) {
    Action? action;

    switch (input) {
      case Input.rest:
        action = RestAction();
        break;

      case Input.nextUnit:
        game.stage.advanceActor();
        break;
      case Input.prevUnit:
        game.stage.previousActor();
        break;
    }

    if (action != null) {
      var unit = game.stage.currentActor as Unit;
      unit.setNextAction(action);
    }

    return true;
  }

  @override
  void activate(Screen popped, Object? result) {

  }

  @override
  void update() {
    game.update();

    dirty();
  }

  @override
  void resize(Vec size) {
    var leftWidth = 20;
    
    _sidebarPanel.show(Rect(size.x - leftWidth, 0, leftWidth, size.y));

    var logHeight = 8;

    _logPanel.show(Rect(0, size.y - logHeight, size.x - leftWidth, logHeight));
    _stagePanel.show(Rect(0, 0, size.x - leftWidth, size.y - logHeight));
  }

  @override
  void render(Terminal terminal) {
    terminal.clear();

    _stagePanel.render(terminal);
    _sidebarPanel.render(terminal);
    _logPanel.render(terminal);
  }
}