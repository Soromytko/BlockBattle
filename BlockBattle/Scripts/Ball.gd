class_name Ball extends KinematicBody2D

var velocity : Vector2 setget set_velocity, get_velocity
func set_velocity(value : Vector2): velocity = value
func get_velocity(): return velocity
	
var speed : float = 10 setget set_speed, get_speed
func set_speed(value : float): speed = value
func get_speed(): return speed


func _ready():
	velocity.y = 1

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var kinematic_collision = move_and_collide(velocity * speed)
	if kinematic_collision:
		velocity = velocity.bounce(kinematic_collision.get_normal())
		var collider = kinematic_collision.get_collider()
		if collider is Block:
			var block : Block = collider
			block.take_damage()

