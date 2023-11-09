extends Node2D

export(NodePath) var point_start_path
export(NodePath) var point_end_path

onready var _point_start : Node2D = get_node(point_start_path)
onready var _point_end : Node2D = get_node(point_end_path)


func _physics_process(delta):
	var start_pos : Vector2 = _point_start.global_position
	var end_pos : Vector2 = _point_end.global_position
	var direction : Vector2 = start_pos - end_pos
	var center : Vector2 = (start_pos + end_pos) / 2
	
	global_position = center
	scale.y = direction.length()
	rotation = -direction.angle_to(Vector2.UP)
