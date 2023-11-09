extends Node2D

export(NodePath) var body_path
onready var _body = get_node(body_path)

export(NodePath) var spring_path
onready var _spring : SpringBody = get_node(spring_path)

var _holding : bool = false


func _process(delta):
	_holding = Input.is_mouse_button_pressed(BUTTON_LEFT)
	

func _physics_process(delta):
	if _holding:
		var force = (get_global_mouse_position() - _spring.global_position) * _spring.stiffness
		_spring.apply_force(force)
