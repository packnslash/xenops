import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

abstract class Panel {
  Rect? _bounds;

  Rect get bounds => _bounds!;

  bool get isVisible => _bounds != null;

  void hide() {
    _bounds = null;
  }

  void show(Rect bounds) {
    _bounds = bounds;
  }

  void render(Terminal terminal) {
    if (isVisible) {
      renderPanel(terminal.rect(bounds.x, bounds.y, bounds.width, bounds.height));
    }
  }

  void renderPanel(Terminal terminal);
}