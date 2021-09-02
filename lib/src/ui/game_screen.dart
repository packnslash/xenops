import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:xenops/src/content/research/topics.dart';
import 'package:xenops/src/engine/action/action.dart';
import 'package:xenops/src/engine/action/behavior.dart';

import '../engine/core/game.dart';
import '../engine/unit/unit.dart';
import '../engine/unit/city.dart';

import 'input.dart';
import 'panel/log_panel.dart';
import 'panel/sidebar_panel.dart';
import 'panel/stage_panel.dart';

class GameScreen extends Screen<Input> {
  final Game game;

  final LogPanel _logPanel;
  late final SidebarPanel _sidebarPanel;
  late final StagePanel _stagePanel;

  bool _changingResearch = false;
  int _selectedResearchIndex = -1;
  int get selectedResearchIndex => _selectedResearchIndex;

  GameScreen(this.game) : _logPanel = LogPanel(game.log) {
    _stagePanel = StagePanel(this);
    _sidebarPanel = SidebarPanel(this);
  }

  factory GameScreen.town(Content content) {
    var game = Game(content, width: 93, height: 93);
    game.buildStage();

    return GameScreen(game);
  }

  @override
  bool handleInput(Input input) {
    if (game.stage.currentActor is City) {
      var city = game.stage.currentActor as City;

      if (_changingResearch) {
        switch (input) {
          case Input.scrollDown:
            _changeResearch(1, city.research.incompleteTopics.length - 1);
            return true;
          case Input.scrollUp:
            _changeResearch(-1, city.research.incompleteTopics.length - 1);
            return true;
          case Input.select:
            var topic = city.research.incompleteTopics.elementAt(_selectedResearchIndex);
            city.setNextResearch(topic);
            _changingResearch = false;
            _selectedResearchIndex = -1;
            dirty();
            return true;
          default:
            _changingResearch = false;
            _selectedResearchIndex = -1;
            dirty();
            return true;
        }
      } else {
        switch (input) {
          case Input.pass:
            if (city.lastBehavior != null) {
              city.continueBehavior();
            } else {
              city.behavior = ActionBehavior(PassAction());
            }
            return true;
          case Input.changeResearch:
            if (city.research.incompleteTopics.isNotEmpty) {
              _changingResearch = true;
              _selectedResearchIndex = 0;
              dirty();
            }
            return true;
        }
      }
    } else if (game.stage.currentActor is Unit) {
      var unit = game.stage.currentActor as Unit;

      Action? action;

      switch (input) {
        case Input.pass:
          action = PassAction();
          break;
        case Input.rest:
          action = RestAction();
          break;
        case Input.n:
          action = WalkAction(Direction.n);
          break;
        case Input.ne:
          action = WalkAction(Direction.ne);
          break;
        case Input.e:
          action = WalkAction(Direction.e);
          break;
        case Input.se:
          action = WalkAction(Direction.se);
          break;
        case Input.s:
          action = WalkAction(Direction.s);
          break;
        case Input.sw:
          action = WalkAction(Direction.sw);
          break;
        case Input.w:
          action = WalkAction(Direction.w);
          break;
        case Input.nw:
          action = WalkAction(Direction.nw);
          break;
      }

      if (action != null) {
        unit.setNextAction(action);
      }
    }

    return true;
  }

  @override
  void update() {
    var result = game.update();

    if (result.needsRefresh) dirty();
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

  void _changeResearch(int offset, int max) {
    var index = (_selectedResearchIndex + offset).clamp(0, max);
    if (index != _selectedResearchIndex) {
      _selectedResearchIndex = index;
      dirty();
    }
  }
}