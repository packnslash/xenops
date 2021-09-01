

class Input {
  static const rest = Input('rest');
  static const pass = Input('pass');
  static const changeResearch = Input('change research');

  static const nextUnit = Input('next unit');
  static const prevUnit = Input('previous unit');
  
  static const scrollDown = Input('scroll down');
  static const scrollUp = Input('scroll up');
  static const select = Input('select');

  final String name;

  const Input(this.name);
}