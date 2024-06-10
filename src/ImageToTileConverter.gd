extends Node2D

class_name ImageToTilemapConverter

enum TileType {
	DEEP_WATER = 0,
	WATER = 1,
	GRASS = 2,
	RICH_SOIL_GRASS = 3,
	SAND = 4
}

var tile_atlas_coords : Dictionary = {
		TileType.DEEP_WATER		: Vector2i(0, 0),
		TileType.WATER				: Vector2i(1, 0),
		TileType.GRASS				: Vector2i(2, 0),
		TileType.RICH_SOIL_GRASS	: Vector2i(3, 0),
		TileType.SAND				: Vector2i(4, 0)
	}
@export var m_tilemap : TileMap
var _m_tileset : TileSet

func _ready():
	_m_tileset = ResourceLoader.load("res://res/terrain.tres")
	
	if m_tilemap != null:
		m_tilemap.tile_set = _m_tileset

func convert_to_tilemap(terrain : Array[Array]):
		

	for y in range(terrain.size()):
		var row = terrain[y]
		for x in range(terrain[0].size()):
			var tiletype : TileType = row[x]
			var atlas_coords = tile_atlas_coords[tiletype]
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
	
	var result : Array[Array] = []
	var col : Color = Palettes.DEEP_WATER_COLOR
	var cur_tile : TileType = TileType.DEEP_WATER
	for y in range(image.get_height()):
		var row = []
		for x in range(image.get_width()):
			var last_col = col
			col = image.get_pixel(x, y)
			
			if !col == last_col:
				if col == Palettes.DEEP_WATER_COLOR:
					cur_tile = TileType.DEEP_WATER
				elif col == Palettes.WATER_COLOR:
					cur_tile = TileType.WATER
				elif col == Palettes.SAND_COLOR:
					cur_tile = TileType.SAND
				elif col == Palettes.GRASS_COLOR:
					cur_tile = TileType.GRASS
				elif col == Palettes.RICH_GRASS_COLOR:
					cur_tile = TileType.RICH_SOIL_GRASS
					
			row.append(cur_tile)
		result.append(row)
	convert_to_tilemap(result)
