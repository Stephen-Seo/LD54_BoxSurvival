extends Node2D

@onready var arenaBody = $StaticBody2D
@onready var player = $CharacterBody2D
var projectile = preload("res://circleProjectiles.tscn")

const WAVE_TIME = 5.0
const PROJECTILE_DISTANCE = 1500
const PROJECTILE_VELOCITY = 500

var wave_timer = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.health <= 0:
		return
	if arenaBody.scale.x > 0.1:
		arenaBody.scale -= arenaBody.scale * 0.01 * delta
	wave_timer += delta
	if wave_timer >= WAVE_TIME:
		wave_timer = 0
		for i in range(10):
			var projectile_instance = projectile.instantiate()
			var random_angle = randf_range(0.0, PI * 2.0)
			var projectile_sprite = projectile_instance.find_child("Sprite2D")
			projectile_instance.position = Vector2(cos(random_angle) * PROJECTILE_DISTANCE + player.position.x, sin(random_angle) * PROJECTILE_DISTANCE + player.position.y)
			projectile_instance.linear_velocity = Vector2(-cos(random_angle) * PROJECTILE_VELOCITY, -sin(random_angle) * PROJECTILE_VELOCITY)
			projectile_sprite.self_modulate = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0))
			add_child(projectile_instance)

func do_restart():
	get_tree().reload_current_scene()

func on_player_death():
	var button = Button.new()
	button.position = Vector2(0, -50)
	button.add_theme_font_size_override("font_size", 40)
	button.text = "Restart?"
	button.pressed.connect(do_restart)
	player.add_child(button)
