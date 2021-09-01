
class TileType {
  static final uninitialized = TileType('uninitialized', null);

  final String name;
  final Object? appearance;

  TileType(this.name, this.appearance);
}

class Tile {
  TileType type = TileType.uninitialized;
}