extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0

const DEFAULT_COLOR = Color(0.7, 0.7, 0.85)
const HURT_COLOR = Color(1.0, 0.2, 0.2)

const HURT_TIME = 0.5

const MAX_PARTICLE_VELOCITY = 1500
const MIN_PARTICLE_VELOCITY = 550

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var health = 5
var hurt_timer = 0.0

@onready var text_label = $TimerLabel
var text_timer = 0.0
var text_format = "%.1f"

@onready var health_label = $HPLabel
var health_text_format = "%d"

@onready var self_sprite = $Sprite2D

var particle = preload("res://circleParticle.tscn")

@onready var hit_sfx = $HitSFX
@onready var jump_sfx = $JumpSFX

@onready var title_text = $GameTitleText
var title_timer = 5.0

@onready var touch_jump = $JumpTouchButton
@onready var touch_left = $LeftTouchButton
@onready var touch_right = $RightTouchButton

@onready var jump_label = $JumpTouchButton/JumpLabel
@onready var left_label = $LeftTouchButton/LeftLabel
@onready var right_label = $RightTouchButton/RightLabel

func _ready():
	self_sprite.self_modulate = DEFAULT_COLOR
	health_label.text = health_text_format % health
	title_text.add_theme_font_size_override("normal_font_size", 40)
	title_text.add_text("LD54 - Box Survival\nBy: BurnedKirby\nMade in Godot\nWAD or Touch to move")
	var somewhat_transparent_color = Color(1, 1, 1, 0.3)
	text_label.label_settings.font_color = somewhat_transparent_color
	health_label.label_settings.font_color = somewhat_transparent_color
	jump_label.label_settings.font_color = somewhat_transparent_color
	left_label.label_settings.font_color = somewhat_transparent_color
	right_label.label_settings.font_color = somewhat_transparent_color

func _physics_process(delta):
	if title_timer > 0.0:
		title_timer -= delta
		if title_timer < 0.0:
			title_timer = 0.0
			title_text.get_parent().remove_child(title_text)
			var white = Color(1, 1, 1, 1)
			text_label.label_settings.font_color = white
			health_label.label_settings.font_color = white
			jump_label.label_settings.font_color = white
			left_label.label_settings.font_color = white
			right_label.label_settings.font_color = white

	if health <= 0:
		return
	
	text_timer += delta
	text_label.text = text_format % text_timer
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y /= 3.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	hurt_timer -= delta
	if hurt_timer < 0.0:
		hurt_timer = 0.0
		self_sprite.self_modulate = DEFAULT_COLOR
		
func spawn_particle(color):
	var particle_instance = particle.instantiate()
	particle_instance.find_child("Sprite2D").self_modulate = color
	var random_angle = randf_range(0.0, PI * 2.0)
	particle_instance.position = self.position
	var vel = randf_range(MIN_PARTICLE_VELOCITY, MAX_PARTICLE_VELOCITY)
	particle_instance.linear_velocity = Vector2(cos(random_angle) * vel, sin(random_angle) * vel)
	get_parent().add_child(particle_instance)

func damaged(projectile):
	var projectile_color = projectile.find_child("Sprite2D").self_modulate
	for i in range(50):
		spawn_particle(projectile_color)
	if hurt_timer == 0.0:
		health -= 1
		health_label.text = health_text_format % health
		self_sprite.self_modulate = HURT_COLOR
		hurt_timer = HURT_TIME
		hit_sfx.play()
		if health <= 0:
			velocity = Vector2(0, 0)
			collision_layer = 0
			collision_mask = 0
			self_sprite.self_modulate = Color(0, 0, 0, 0)
			for i in range(100):
				spawn_particle(Color(1, 1, 1))
			get_parent().on_player_death()
			touch_jump.hide()
			touch_left.hide()
			touch_right.hide()
