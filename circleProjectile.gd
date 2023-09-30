extends RigidBody2D

const Player = preload("res://PlayerCharacterBody2D.gd")

const LIFETIME = 18.0
var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(4)

func on_collide():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer >= LIFETIME:
		get_parent().remove_child(self)
	for collider in get_colliding_bodies():
		if collider is Player:
			collider.damaged(self)
			get_parent().remove_child(self)
			break
