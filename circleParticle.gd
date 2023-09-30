extends RigidBody2D

const LIFETIME = 5

var timer = 0.0

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer >= LIFETIME:
		get_parent().remove_child(self)
	else:
		sprite.self_modulate.a = 1.0 - timer / LIFETIME
