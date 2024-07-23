extends Node2D

class_name TerrainInstantiator

enum TileType {
	DEEP_WATER = 0,
	WATER = 1,
	GRASS = 2,
	FOREST_GRASS = 3,
	SAND = 4
}

static var TILE_ATLAS_COORDS : Dictionary = {
	TileType.DEEP_WATER        : Vector2i(0, 0),
	TileType.WATER             : Vector2i(1, 0),
	TileType.GRASS             : Vector2i(2, 0),
	TileType.FOREST_GRASS   : Vector2i(3, 0),
	TileType.SAND              : Vector2i(4, 0)
}

var m_tilemap : TileMap

func convert_to_tilemap(terrain : Array):
	for y in range(terrain.size()):
		var row = terrain[y]
		for x in range(row.size()):
			var tiletype : TileType = row[x]
			var atlas_coords = TILE_ATLAS_COORDS[tiletype]
			if atlas_coords == null:
				continue
			else:
				m_tilemap.set_cell(
					0,
					Vector2i(x, y),
					0,
					atlas_coords
				)

func image_to_tilemap(image : Image):
	var result : Array = []
	var cur_tile : TileType = TileType.DEEP_WATER
	for y in range(image.get_height()):
		var row = []
		for x in range(image.get_width()):
			var col = image.get_pixel(x, y)
			
			if col == Palettes.DEEP_WATER_COLOR:
				cur_tile = TileType.DEEP_WATER
			elif col == Palettes.WATER_COLOR:
				cur_tile = TileType.WATER
			elif col == Palettes.SAND_COLOR:
				cur_tile = TileType.SAND
			elif col == Palettes.GRASS_COLOR:
				cur_tile = TileType.GRASS
			elif col == Palettes.RICH_GRASS_COLOR:
				cur_tile = TileType.FOREST_GRASS
				
			row.append(cur_tile)
		result.append(row)
	convert_to_tilemap(result)
	
static func get_tile_type(atlas_coords : Vector2i):
	if TILE_ATLAS_COORDS.values().has(atlas_coords):
		var idx = TILE_ATLAS_COORDS.values().find(atlas_coords)
		return TILE_ATLAS_COORDS.keys()[idx]
	else:
		return Vector2i.ONE * -1;
