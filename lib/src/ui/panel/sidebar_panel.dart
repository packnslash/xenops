import 'package:malison/malison.dart';
import 'package:xenops/src/engine/action/behavior.dart';
import 'package:xenops/src/ui/game_screen.dart';

import '../../engine/unit/city.dart';
import '../../hues.dart';
import '../draw.dart';
import 'panel.dart';

class SidebarPanel extends Panel {
  final GameScreen _gameScreen;

  SidebarPanel(this._gameScreen);

  @override
  void renderPanel(Terminal terminal) {
    Draw.verticalLine(terminal, 0, 0, terminal.height, darkCoolGray);

    var game = _gameScreen.game;
    var target = game.stage.currentActor;

    terminal.writeAt(1, 0, '${target.name}', UIHue.text);
    
    var speed1 = 'AP ';
    var speed2 = '${target.energy.energy}';
    terminal.writeAt(terminal.width - speed1.length - speed2.length - 1, 0, speed1, UIHue.text);
    terminal.writeAt(terminal.width - speed2.length - 1, 0, speed2, UIHue.primary);

    terminal.writeAt(1, 7, 'Actions', UIHue.text);
    Draw.horizontalLine(terminal, 1, 8, terminal.width - 1, UIHue.text);
    terminal.writeAt(1, 9, '[P]ass', UIHue.primary);

    if (target is City) {
      terminal.writeAt(1, 2, 'Current Research', UIHue.text);

      var currentResearch = 'None';
      if (target.lastBehavior != null && target.lastBehavior is ResearchBehavior) {
        var behavior = target.lastBehavior! as ResearchBehavior;
        currentResearch = behavior.topic.name;
      
        var l = '(${behavior.topic.cost - (target.research.progress(behavior.topic) ?? 0)} Turns)';
        terminal.writeAt(terminal.width - l.length - 1, 3, l, UIHue.primary);
      }
      terminal.writeAt(1, 3, '$currentResearch', UIHue.primary);
      terminal.writeAt(1, 11, '[C]hange Research', UIHue.primary);

      terminal.writeAt(1, 14, 'Available Research', UIHue.text);
      Draw.horizontalLine(terminal, 1, 15, terminal.width - 1, UIHue.text);

      var y = 16;
      var i = 0;

      for (var topic in target.research.incompleteTopics) {
        terminal.writeAt(1, y, '${topic.name}', _gameScreen.selectedResearchIndex == i ? UIHue.selection : UIHue.primary);
        
        var l = '(${topic.cost - (target.research.progress(topic) ?? 0)} Turns)';
        terminal.writeAt(terminal.width - l.length - 1, y, l, UIHue.text);
        
        y += 2;
        i += 1;
      }
    }
  }
}