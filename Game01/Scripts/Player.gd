extends RigidBody2D

const SPEED = 300.0
@export var ball : RigidBody2D
var _pressed = false

func _physics_process(delta):
	var direction = Input.get_axis("down", "up")
	linear_velocity.y = -direction * SPEED
	
	if Input.is_key_pressed(KEY_SHIFT):
		if !_pressed:
			ball.linear_velocity.x = 1000
			_pressed = true
	
