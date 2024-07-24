
enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}

enum TileType {
	DEEP_WATER = 0,
	WATER = 1,
	GRASS = 2,
	FOREST_GRASS = 3,
	SAND = 4
}

var TILE_ATLAS_COORDS : Dictionary = {
	TileType.DEEP_WATER        : Vector2i(0, 0),
	TileType.WATER             : Vector2i(1, 0),
	TileType.GRASS             : Vector2i(2, 0),
	TileType.FOREST_GRASS   : Vector2i(3, 0),
	TileType.SAND              : Vector2i(4, 0)
}
