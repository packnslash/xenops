

class Input {
  static const rest = Input('rest');
  static const pass = Input('pass');
  static const changeResearch = Input('change research');

  static const nextUnit = Input('next unit');
  static const prevUnit = Input('previous unit');
  
  static const scrollDown = Input('scroll down');
  static const scrollUp = Input('scroll up');
  static const select = Input('select');

  static const n = Input('n');
  static const e = Input('e');
  static const s = Input('s');
  static const w = Input('w');
  static const ne = Input('ne');
  static const nw = Input('nw');
  static const se = Input('se');
  static const sw = Input('sw');

  final String name;

  const Input(this.name);
}