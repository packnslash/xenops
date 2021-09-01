import 'package:malison/malison.dart';

import '../../hues.dart';
import '../draw.dart';
import 'panel.dart';

class SidebarPanel extends Panel {
  @override
  void renderPanel(Terminal terminal) {
    for (var y = 0; y < terminal.height; y++) {
      terminal.writeAt(0, y, '│', darkCoolGray);
    }
    terminal.writeAt(1, 0, 'Sidebar Title ', UIHue.text);
  }
}