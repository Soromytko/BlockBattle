extends Node2D

@export var units : Array[PackedScene]

@export var radius : float = 10

@export var hexagon_scene : PackedScene
@export var red : PackedScene
@export var green : PackedScene
@export var blue : PackedScene
@export var yellow : PackedScene
@export var pink : PackedScene

var _debug_unit : Node2D
var _brash_unit
var _units = {}


func _input(event):
	if Input.is_key_pressed(KEY_S):
		_save_to_file()
	elif Input.is_key_pressed(KEY_L):
		_load_from_file()


func _ready():
	_debug_unit = hexagon_scene.instantiate()
	add_child(_debug_unit)


func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos = get_global_mouse_position()
	var hex_pos = _to_hex_pos(mouse_pos)
	_debug_unit.global_position = hex_pos
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !_units.has(hex_pos):
			var hexagon : Polygon2D = hexagon_scene.instantiate()
			hexagon.color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)
			add_child(hexagon)
			hexagon.global_position = hex_pos
			_units[hex_pos] = hexagon
			

func _to_hex_pos(pos : Vector2):
	var h : float = radius * sqrt(3) / 2.0
	var box_size : Vector2 = Vector2(h * 4, (radius + h / 2) * 2)
	var box_pos = Vector2(round(pos.x / box_size.x) * box_size.x, round(pos.y / box_size.y) * box_size.y)
	var half_box_size = box_size / 2
	var quarter_box_size = half_box_size / 2
	var points = [
		box_pos + Vector2(half_box_size.x, 0),
		box_pos + Vector2(quarter_box_size.x, half_box_size.y),
		box_pos + Vector2(-quarter_box_size.x, half_box_size.y),
		box_pos + Vector2(-half_box_size.x, 0),
		box_pos + Vector2(-quarter_box_size.x, -half_box_size.y),
		box_pos + Vector2(-quarter_box_size.x, +half_box_size.y),
	]
	var dist = pos.distance_to(box_pos)
	var nearest_point = box_pos
	for point in points:
		var cur_dist : float = pos.distance_to(point)
		if cur_dist < dist:
			dist = cur_dist
			nearest_point = point
	return nearest_point


func _save_to_file(path : String = "res://mosaic_editor_scene.mes"):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file.is_open():
		for key in _units:
			var value : Polygon2D = _units[key]
			file.store_float(key.x)
			file.store_float(key.y)
			file.store_float(value.color.r)
			file.store_float(value.color.g)
			file.store_float(value.color.b)
		file.close()


func _load_from_file(path : String = "res://mosaic_editor_scene.mes"):
	var file = FileAccess.open(path, FileAccess.READ)
	if file.is_open():
		for key in _units: _units[key].queue_free()
		_units.clear()
		while file.get_position() < file.get_length():
			var pos : Vector2 = Vector2(file.get_float(), file.get_float())
			var color : Color = Color(file.get_float(), file.get_float(), file.get_float(), 1)
			var hexagon : Polygon2D = hexagon_scene.instantiate()
			add_child(hexagon)
			hexagon.global_position = pos
			hexagon.color = color
			_units[pos] = hexagon
		file.close()
		
