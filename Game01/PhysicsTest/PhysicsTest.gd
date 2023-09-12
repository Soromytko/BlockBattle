extends Node

@export var box_scene : PackedScene
@export var time_out_sec : float = 0.05

var _time : float = 0
func _physics_process(delta):
	_time += delta
	if _time >= time_out_sec:
		_time -= time_out_sec
		var box = box_scene.instantiate()
		add_child(box)
	
