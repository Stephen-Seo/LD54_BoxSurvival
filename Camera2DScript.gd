extends Camera2D

const TARGET_MIN_DIM = 800.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_size = get_viewport_rect().size
	var min_xy = viewport_size.x if viewport_size.x < viewport_size.y else viewport_size.y
	var ratio = min_xy / TARGET_MIN_DIM
	zoom.x += (ratio - zoom.x) * 0.005
	zoom.y = zoom.x
	print_debug(scale)
