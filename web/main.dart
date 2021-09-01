import 'dart:html' as html;
import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';

import 'package:xenops/src/ui/game_screen.dart';
import 'package:xenops/src/ui/input.dart';

late final UserInterface<Input> _ui;

late final canvas;
late RenderableTerminal terminal;

const charWidth = 16;
const charHeight = 16;

void main() {
  canvas = html.CanvasElement();

  terminal = _makeTerminal(canvas, charWidth, charHeight);

  var div = html.querySelector('#game')!;
  div.append(canvas);

  html.window.onResize.listen((_) {
    _resizeTerminal();
  });

  _ui = UserInterface<Input>(terminal);

  _ui.keyPress.bind(Input.rest, KeyCode.r);
  _ui.keyPress.bind(Input.nextUnit, KeyCode.e);
  _ui.keyPress.bind(Input.prevUnit, KeyCode.q);

  _ui.push(GameScreen.town());

  _ui.handlingInput = true;
  _ui.running = true;
}

RetroTerminal _makeTerminal(html.CanvasElement canvas, int charWidth, int charHeight) {
  var width = (html.document.body!.clientWidth - 20) ~/ charWidth;
  var height = (html.document.body!.clientHeight - 30) ~/ charHeight;

  width = math.max(width, 80);
  height = math.max(height, 40);

  var scale = html.window.devicePixelRatio.toInt();
  var canvasWidth = charWidth * width;
  var canvasHeight = charHeight * height;
  canvas.width = canvasWidth * scale;
  canvas.height = canvasHeight * scale;
  canvas.style.width = '${canvasWidth}px';
  canvas.style.height = '${canvasHeight}px';

  return RetroTerminal(width, height, 'font_16.png', canvas: canvas, charWidth: charWidth, charHeight: charHeight, scale: scale);
}

void _resizeTerminal() {
  terminal = _makeTerminal(canvas, charWidth, charHeight);
  _ui.setTerminal(terminal);
}
