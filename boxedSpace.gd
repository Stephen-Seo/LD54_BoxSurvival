extends Node2D

@onready var arenaBody = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if arenaBody.scale.x > 0.1:
		arenaBody.scale -= arenaBody.scale * 0.01 * delta
