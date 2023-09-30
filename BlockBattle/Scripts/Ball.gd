class_name Ball extends CharacterBody2D

var direction : Vector2:
	get: return velocity
	set(value): velocity = value
	
var speed : float = 20:
	get: return speed
	set(value): speed = value
	

var _pressed = false
	

func _process(delta):
	if Input.is_key_pressed(KEY_SHIFT):
		if !_pressed:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			_pressed = true


func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
#	direction = (mouse_pos - global_position).normalized()
#	print(mouse_pos - global_position)
	var kinematic_collision = move_and_collide(velocity * speed)
	
	if kinematic_collision:
		velocity = velocity.bounce(kinematic_collision.get_normal())
		var collider = kinematic_collision.get_collider()
		if collider is Block:
			var block : Block = collider
			block.take_damage()

