extends NavigationRegion2D

class_name TilemapNavigationManager

var terrain_tilemap: TileMap
var obstacle_tilemap: TileMap

var walkable_tile_atlas_coords : Array = [
	TerrainInstantiator.TILE_ATLAS_COORDS.get(TerrainInstantiator.TileType.GRASS),
	TerrainInstantiator.TILE_ATLAS_COORDS.get(TerrainInstantiator.TileType.FOREST_GRASS),
	TerrainInstantiator.TILE_ATLAS_COORDS.get(TerrainInstantiator.TileType.SAND),
]

var cabin : Node2D

var walkable_tiles : Array
var obstacles : Array

func _ready():
	var mapgen : MapGenerator = get_node("../MapGenerator")
	mapgen.instantiation_complete.connect(generate_nav_region)

func generate_nav_region():
	terrain_tilemap = get_node("../../YSorted/Tilemaps/TerrainTilemap")
	obstacle_tilemap = get_node("../../YSorted/Tilemaps/DestructibleTilemap")
	cabin = get_node("../../YSorted/Buildings/Cabin")
	update_nav_region()
	
func update_nav_region():
	print("updating nav region")
	var bounds = terrain_tilemap.get_used_rect()
	var start = bounds.position
	var end = bounds.position + bounds.size * terrain_tilemap.tile_set.tile_size
	
	print(start, end)
	
	var nav_polygon = self.navigation_polygon
	# Create a navigation polygon that covers the entire bounds of the terrain tilemap
	var poly_points = [
		start,
		Vector2(start.x + end.x, start.y),
		start + end,
		Vector2(start.x, start.y + end.y)
	]
	nav_polygon.add_outline(poly_points)
	
	nav_polygon.make_polygons_from_outlines()
	self.bake_navigation_polygon()

	
	var cabin_outline : CollisionPolygon2D = cabin.get_node("InteriorArea2D/CollisionPolygon2D")

	nav_polygon.add_outline(xform_packed_array(cabin_outline.polygon, cabin_outline.global_transform))
	print("poly count: ", nav_polygon.get_polygon_count())

	print("poly count: ", nav_polygon.get_polygon_count())	
	
	nav_polygon.make_polygons_from_outlines()
	
	self.navigation_polygon = nav_polygon

func xform_packed_array(arr : PackedVector2Array, t : Transform2D) -> PackedVector2Array:
	var result : PackedVector2Array = PackedVector2Array()
	for point in arr:
		var xformed = t.basis_xform_inv(point) + t.get_origin()
		var padding = 30 * Vector2(sign(xformed.x - t.get_origin().x), sign(xformed.y - t.get_origin().y))
		result.append(xformed + padding)
	return result
