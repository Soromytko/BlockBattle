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
		var units_data = {}
		for pos in _units: units_data[pos] = MosaicFileManager.MosaicUnitData.new(_units[pos].color)
		MosaicFileManager.save_to_file(units_data)
	elif Input.is_key_pressed(KEY_L):
		var new_units_data = MosaicFileManager.load_from_file()
		if new_units_data.size() > 0:
			var asdf: Node2D
			for pos in _units: _units[pos].queue_free()
			_units.clear()
			for pos in new_units_data:
				var unit : Polygon2D = hexagon_scene.instantiate()
				add_child(unit)
				unit.global_position = pos
				unit.color = new_units_data[pos].color


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

