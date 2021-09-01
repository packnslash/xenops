import 'package:malison/malison.dart';
import '../hues.dart';

class Draw {
  static void box(Terminal terminal, int x, int y, int width, int height,
      [Color? color]) {
    _box(terminal, x, y, width, height, color, '┌', '─', '┐', '│', '└', '─',
        '┘');
  }

  static void frame(Terminal terminal, int x, int y, int width, int height,
      [Color? color]) {
    _box(terminal, x, y, width, height, color, '╒', '═', '╕', '│', '└', '─',
        '┘');
  }

  static void doubleBox(Terminal terminal, int x, int y, int width, int height,
      [Color? color]) {
    _box(terminal, x, y, width, height, color, '╔', '═', '╗', '║', '╚', '═',
        '╝');
  }

  static void helpKeys(Terminal terminal, Map<String, String> helpKeys,
      [String? query]) {
    // Draw the help.
    var helpTextLength = 0;
    helpKeys.forEach((key, text) {
      if (helpTextLength > 0) helpTextLength += 2;
      helpTextLength += key.length + text.length + 3;
    });

    var x = (terminal.width - helpTextLength) ~/ 2;

    // Show the query string, if there is one.
    if (query != null) {
      box(terminal, x - 2, terminal.height - 4, helpTextLength + 4, 5,
          UIHue.text);
      terminal.writeAt((terminal.width - query.length) ~/ 2,
          terminal.height - 3, query, UIHue.primary);
    } else {
      box(terminal, x - 2, terminal.height - 2, helpTextLength + 4, 3,
          UIHue.text);
    }

    var first = true;
    helpKeys.forEach((key, text) {
      if (!first) {
        terminal.writeAt(x, terminal.height - 1, ', ', UIHue.secondary);
        x += 2;
      }

      terminal.writeAt(x, terminal.height - 1, '[', UIHue.secondary);
      x++;
      terminal.writeAt(x, terminal.height - 1, key, UIHue.selection);
      x += key.length;
      terminal.writeAt(x, terminal.height - 1, '] ', UIHue.secondary);
      x += 2;

      terminal.writeAt(x, terminal.height - 1, text, UIHue.helpText);
      x += text.length;

      first = false;
    });
  }

  static void _box(
      Terminal terminal,
      int x,
      int y,
      int width,
      int height,
      Color? color,
      String topLeft,
      String top,
      String topRight,
      String vertical,
      String bottomLeft,
      String bottom,
      String bottomRight) {
    color ??= darkCoolGray;
    var bar = vertical + ' ' * (width - 2) + vertical;
    for (var row = y + 1; row < y + height - 1; row++) {
      terminal.writeAt(x, row, bar, color);
    }

    var topRow = topLeft + top * (width - 2) + topRight;
    var bottomRow = bottomLeft + bottom * (width - 2) + bottomRight;
    terminal.writeAt(x, y, topRow, color);
    terminal.writeAt(x, y + height - 1, bottomRow, color);
  }
}