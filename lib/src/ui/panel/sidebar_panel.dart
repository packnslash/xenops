import 'package:malison/malison.dart';
import 'package:xenops/src/engine/action/behavior.dart';
import 'package:xenops/src/ui/game_screen.dart';

import '../../engine/unit/city.dart';
import '../../hues.dart';
import 'panel.dart';

class SidebarPanel extends Panel {
  final GameScreen _gameScreen;

  SidebarPanel(this._gameScreen);

  @override
  void renderPanel(Terminal terminal) {
    for (var y = 0; y < terminal.height; y++) {
      terminal.writeAt(0, y, '│', darkCoolGray);
    }

    var game = _gameScreen.game;
    var target = game.stage.currentActor;

    terminal.writeAt(1, 0, '${target.name}', UIHue.text);
    terminal.writeAt(1, 7, 'Actions', UIHue.text);
    terminal.writeAt(1, 8, '─' * (terminal.width - 2), UIHue.text);
    terminal.writeAt(1, 9, '[P]ass', UIHue.primary);

    if (target is City) {
      terminal.writeAt(1, 2, 'Current Research', UIHue.text);

      var currentResearch = 'None';
      if (target.lastBehavior != null && target.lastBehavior is ResearchBehavior) {
        var behavior = target.lastBehavior! as ResearchBehavior;
        currentResearch = behavior.topic.name;
      
        var l = '(${target.research.progress(behavior.topic) ?? 0}/${behavior.topic.cost})';
        terminal.writeAt(terminal.width - l.length - 1, 3, l, UIHue.primary);
      }
      terminal.writeAt(1, 3, '$currentResearch', UIHue.primary);
      terminal.writeAt(1, 11, '[C]hange Research', UIHue.primary);

      var y = 13;
      var i = 0;

      for (var topic in target.research.incompleteTopics) {
        terminal.writeAt(1, y, '${i+1} ${topic.name}', _gameScreen.selectedResearchIndex == i ? UIHue.selection : UIHue.primary);
        
        var l = '(${target.research.progress(topic) ?? 0}/${topic.cost})';
        terminal.writeAt(terminal.width - l.length - 1, y, l, UIHue.primary);
        
        y += 2;
        i += 1;
      }
    }
  }
}