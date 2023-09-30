extends Node2D

@onready var arenaBody = $StaticBody2D
@onready var player = $CharacterBody2D
@onready var music = $AudioStreamPlayer
var projectile = preload("res://circleProjectiles.tscn")

const WAVE_TIME = 5.0
const PROJECTILE_DISTANCE = 1500
const PROJECTILE_VELOCITY = 500
const HORIZONTAL_WAVE_COLOR = Color(1, 0, 1)
const HORIZONTAL_WAVE_COLOR_ALT = Color(1, 1, 0)
const VERTICAL_WAVE_COLOR = Color(0, 1, 1)
const VERTICAL_WAVE_COLOR_ALT = Color(0, 1, 0)

var wave_timer = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func wave_random():
	for i in range(10):
		var projectile_instance = projectile.instantiate()
		var random_angle = randf_range(0.0, PI * 2.0)
		var projectile_sprite = projectile_instance.find_child("Sprite2D")
		projectile_instance.position = Vector2(cos(random_angle) * PROJECTILE_DISTANCE + player.position.x, sin(random_angle) * PROJECTILE_DISTANCE + player.position.y)
		projectile_instance.linear_velocity = Vector2(-cos(random_angle) * PROJECTILE_VELOCITY, -sin(random_angle) * PROJECTILE_VELOCITY)
		projectile_sprite.self_modulate = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0))
		add_child(projectile_instance)

func wave_horizontal():
	var left = true if randi_range(0, 1) == 0 else false
	for i in range(8):
		var projectile_instance = projectile.instantiate()
		var random_angle = 0
		if left:
			random_angle = randf_range(-PI / 2.0, PI / 2.0)
		else:
			random_angle = randf_range(PI / 2.0, PI * 3.0 / 2.0)
		var projectile_sprite = projectile_instance.find_child("Sprite2D")
		projectile_instance.position = Vector2(cos(random_angle) * PROJECTILE_DISTANCE + player.position.x, sin(random_angle) * PROJECTILE_DISTANCE + player.position.y)
		projectile_instance.linear_velocity = Vector2(-cos(random_angle) * PROJECTILE_VELOCITY, -sin(random_angle) * PROJECTILE_VELOCITY)
		projectile_sprite.self_modulate = HORIZONTAL_WAVE_COLOR if left else HORIZONTAL_WAVE_COLOR_ALT
		add_child(projectile_instance)

func wave_vertical():
	var up = true if randi_range(0, 1) == 0 else false
	for i in range(8):
		var projectile_instance = projectile.instantiate()
		var random_angle = 0
		if up:
			random_angle = randf_range(0, PI)
		else:
			random_angle = randf_range(PI, PI * 2.0)
		var projectile_sprite = projectile_instance.find_child("Sprite2D")
		projectile_instance.position = Vector2(cos(random_angle) * PROJECTILE_DISTANCE + player.position.x, sin(random_angle) * PROJECTILE_DISTANCE + player.position.y)
		projectile_instance.linear_velocity = Vector2(-cos(random_angle) * PROJECTILE_VELOCITY, -sin(random_angle) * PROJECTILE_VELOCITY)
		projectile_sprite.self_modulate = VERTICAL_WAVE_COLOR if up else VERTICAL_WAVE_COLOR_ALT
		add_child(projectile_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.health <= 0:
		return
	if arenaBody.scale.x > 0.1:
		arenaBody.scale -= arenaBody.scale * 0.01 * delta
	wave_timer += delta
	if wave_timer >= WAVE_TIME:
		wave_timer = 0
		match randi_range(0, 2):
			0:
				wave_random()
			1:
				wave_horizontal()
			2:
				wave_vertical()
			_:
				wave_random()

func do_restart():
	get_tree().reload_current_scene()

func on_player_death():
	var button = Button.new()
	button.position = Vector2(0, -50)
	button.add_theme_font_size_override("font_size", 40)
	button.text = "Restart?"
	button.pressed.connect(do_restart)
	player.add_child(button)
	music.stop()
