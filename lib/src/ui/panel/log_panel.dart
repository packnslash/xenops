import 'package:malison/malison.dart';

import '../../engine/core/log.dart';
import '../../hues.dart';
import 'panel.dart';

class LogPanel extends Panel {
  final Log _log;

  LogPanel(this._log);

  @override
  void renderPanel(Terminal terminal) {
    var y = terminal.height - 1;
    for (var i = _log.messages.length - 1; i >= 0 && y > 0; i--) {
      var message = _log.messages[i];

      Color color;

      switch (message.type) {
        case LogType.message:
          color = ash;
          break;
        case LogType.error:
          color = red;
          break;
        case LogType.help:
          color = peaGreen;
          break;
      }

      if (i != _log.messages.length - 1) {
        color = color.blend(Color.black, 0.5);
      }

      terminal.writeAt(1, y, message.text, color);

      if (message.count > 1) {
        terminal.writeAt(message.text.length + 1, y, ' (x${message.count})', darkCoolGray);
      }

      y--;
    }
  }
}