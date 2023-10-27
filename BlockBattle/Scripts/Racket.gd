class_name Racket extends KinematicBody2D

export(NodePath) var camera_path
onready var _camera = get_node(camera_path)

#func _ready():
#	var area : Area2D = $Area2D
#	if !area: return
#	area.body_entered.connect(_on_area_2d_body_entered)

#func _input(event):
#	if event is InputEventMouseMotion:
#		cursor_position = event.position
	
	
func _physics_process(delta):
	var cursor_position : Vector2 = _camera.get_local_mouse_position()
	var move_delta = cursor_position.x - global_position.x
	var collision : KinematicCollision2D = move_and_collide(Vector2(move_delta, 0))
	

#func _on_area_2d_body_entered(body):
#	return
#	if body is Ball:
#		var ball : Ball = body
#		var direction = (Vector2(1, ball.global_position.y) - global_position).normalized()
#		ball.direction = direction
#		print(direction)
