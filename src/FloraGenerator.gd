class_name FloraGenerator

var tree_sprite : Sprite2D
var rainfall_weight = 0.6
var terrain_type_weight = 0.4

var terrain_chance_map : Dictionary = {
	Palettes.GRASS_COLOR : 0.3,
	Palettes.RICH_GRASS_COLOR : 0.7
}
func _generate_flora(rainfall_map : Image, terrain_map : Image):
	var result : Array[Vector2i] = []
	
	var tiles_since_tree_placed = 2
	for point in VectorTools.vec2i_range(0, terrain_map.get_width()):
		if tiles_since_tree_placed >= 2:
			var terrain_color = terrain_map.get_pixelv(point)		
			
			if terrain_chance_map.has(terrain_color):
				var rainfall_amount = rainfall_map.get_pixelv(point).v
				var tree_chance = rainfall_amount * rainfall_weight + terrain_chance_map[terrain_color] * terrain_type_weight
				if tree_chance > randf_range(0.3, 0.7):
					result.append(point)
		else: tiles_since_tree_placed += 1
	return result	

func generate_rainfall_map(size : Vector2i):
	var n = FastNoiseLite.new()
	n.seed = randi()
	n.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n.frequency = 0.05
	
	var nmaps = []
	
	for i in range(2):
		n.frequency *= 0.75
		n.seed = randi()
		nmaps.append(n.get_image(size.x, size.y))
		
	var result : Image = Image.create(size.x, size.y, false, Image.FORMAT_RGB8)
	for point in VectorTools.vec2i_range(0, size.x):
		var val : float = 0
		for map in nmaps:
			val += map.get_pixelv(point).v
		
		val /= nmaps.size()
		result.set_pixelv(point, Color.from_hsv(0, 0, val))
	
	return result

func generate_flora(terrain_map : Image):
	var rainfall_map = generate_rainfall_map(terrain_map.get_size())
	return _generate_flora(rainfall_map, terrain_map)
