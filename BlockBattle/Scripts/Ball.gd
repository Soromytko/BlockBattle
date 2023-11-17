class_name Ball extends KinematicBody2D

export(NodePath) var mosaic_sandbox_path
export(float) var some

var velocity : Vector2 setget set_velocity, get_velocity
func set_velocity(value : Vector2): velocity = value
func get_velocity(): return velocity
	
var speed : float = 15 setget set_speed, get_speed
func set_speed(value : float): speed = value
func get_speed(): return speed

onready var _mosaic_sandbox : PhysicsMosaicSandbox = get_node(mosaic_sandbox_path)


func _ready():
	velocity.y = 1


func _physics_process(delta):
	var velocity_before_collision : Vector2 = velocity
	var mouse_pos = get_global_mouse_position()
	var kinematic_collision = move_and_collide(velocity * speed)
	if kinematic_collision:
		var collider = kinematic_collision.get_collider()
		if collider is Racket:
			var racket : Racket = collider
			velocity = (global_position - racket.global_position).normalized()
		else:
			velocity = velocity.bounce(kinematic_collision.get_normal())
			if  collider is Block:
				var block : Block = collider
				_mosaic_sandbox.apply_force_to_unit(block, velocity_before_collision * 400, 400)
				block.take_damage()



						
