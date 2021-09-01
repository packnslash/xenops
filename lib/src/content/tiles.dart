import 'package:malison/malison.dart';

import '../engine/stage/tile.dart';
import '../hues.dart';

class Tiles {

  static final unformed = tile('unformed', '?', coolGray).open();

  static final openOcean = tile('open ocear', '≈', darkBlue).open();
  static final ocean = tile('ocean', '≈', blue).open();
  static final shallow = tile('shallow', '≈', aqua).open();
  static final shore = tile('shore', '≈', lightAqua).open();
  static final beach = tile('beach', 'φ', sandal).open();
  static final plains = tile('plains', '░', peaGreen).open();
  static final forest = tile('forest', '░', sherwood).open();
  static final mountain = tile('mountain', '▓', coolGray).open();

  static _TileBuilder tile(String name, Object char, Color fore, [Color? back]) => 
    _TileBuilder(name, char, fore, back);
}

class _TileBuilder {
  final String name;
  final Glyph glyph;

  factory _TileBuilder(String name, Object char, Color fore, [Color? back]) {
    back ??= darkCoolGray;
    var charCode = char is int ? char : (char as String).codeUnitAt(0);
    
    return _TileBuilder._(name, Glyph.fromCharCode(charCode, fore, back));
  }

  _TileBuilder._(this.name, this.glyph);

  TileType open() {
    return TileType(name, glyph);
  }
}