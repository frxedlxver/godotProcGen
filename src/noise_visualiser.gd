extends Node2D

# Define the size of the texture
var _width : int = 512
var _height : int = 512

# values below this number will be interpreted as black. above it will be white
# lower threshold = more high_color, higher = more low_color
var _threshold : float = 0.6

var low_color : Color = Color.GREEN
var high_color : Color = Color.BLUE

var noise = FastNoiseLite.new()
var noise_image : Image
var noise_texture : ImageTexture

func _ready():
	create_new_noise()
	
func create_new_noise():
	noise_image = generate_noise_image(FastNoiseLite.TYPE_CELLULAR, 0.01, int(randi()), false, true)
	
	noise_image = posterize(noise_image)
	noise_texture = ImageTexture.create_from_image(noise_image)
func _unhandled_key_input(event):
	if (event.is_pressed()):
		create_new_noise()
		queue_redraw()

func get_empty_image(width : int = _width, height : int = _height) -> Image:
		return Image.create(width, height, false, Image.FORMAT_RGB8)


func add_layer_to_image(image : Image, weight : float):
	if noise_image == null:
		_height = image.get_height()
		_width = image.get_width()
		noise_image = get_empty_image()
	
	
	if image == null || weight <= 0: 
		return
	if weight == 1:
		noise_image = image
		return
	
	
	var new_image = get_empty_image()
	##Generate noise image
	#for x in range(_width):
		#for y in range(_height):
			## blend noise_image with image, weighted
	
	
func generate_noise_image(type : FastNoiseLite.NoiseType, frequency : float, seed : int, 
invert : bool, normalize : bool = false, ) -> Image:
	set_noise_data(type, frequency, seed)
	var image = noise.get_image(_width, _height, invert, false, normalize)
	image.resize(1080,1080,Image.INTERPOLATE_NEAREST)
	return image
	
func posterize(image : Image) -> Image:
	
	var newImage = get_empty_image(image.get_width(), image.get_height())
	
	for x in range(newImage.get_width()):
		for y in range(newImage.get_height()):
			var value = image.get_pixel(x, y).v
			if value < _threshold:
				newImage.set_pixel(x, y, low_color)
			else:
				newImage.set_pixel(x, y, high_color)
				
	return newImage

func set_noise_data(type : FastNoiseLite.NoiseType, frequency : float, seed : int):
	if noise == null:
		noise = FastNoiseLite.new()
	
	noise.noise_type = type;
	noise.frequency = frequency
	noise.seed = seed
	
func _draw():
	draw_texture(noise_texture, -noise_texture.get_size() / 2)
