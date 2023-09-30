extends Node2D

export(float) var radius : float = 10

export(PackedScene) var hexagon_scene : PackedScene

var _debug_unit : Node2D
var _brash_unit
var _units = {}

var _brush_color : Color


func _input(event):
	if Input.is_key_pressed(KEY_S):
		_save()
	elif Input.is_key_pressed(KEY_L):
		_load()
	elif Input.is_key_pressed(KEY_R):
		_brush_color = Color.red
	elif Input.is_key_pressed(KEY_G):
		_brush_color = Color.green
	elif Input.is_key_pressed(KEY_B):
		_brush_color = Color.blue
	elif Input.is_key_pressed(KEY_Y):
		_brush_color = Color.yellow
	elif Input.is_key_pressed(KEY_P):
		_brush_color = Color.pink
	elif Input.is_key_pressed(KEY_O):
		_brush_color = Color.orange


func _ready():
	_debug_unit = hexagon_scene.instance()
	add_child(_debug_unit)


func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos = get_global_mouse_position()
	var hex_pos = _to_hex_pos(mouse_pos)
	_debug_unit.global_position = hex_pos
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if !_units.has(hex_pos):
			var hexagon : Polygon2D = hexagon_scene.instance()
#			hexagon.color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)
			hexagon.color = _brush_color
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
	

func _save():
	var mosaic_units = []
	for pos in _units:
		var color : Color = _units[pos].color
		mosaic_units.append(MosaicFileManager.MosaicUnit.new(pos, color))
	MosaicFileManager.save_to_file(mosaic_units)
		
	
func _load():
	var mosaic_units = MosaicFileManager.load_from_file()
	if mosaic_units.size() > 0:
		for pos in _units: _units[pos].queue_free()
		_units.clear()
		for mosaic_unit in mosaic_units:
			var pos : Vector2 = mosaic_unit.position
			var color : Color = mosaic_unit.color
			var unit : Polygon2D = hexagon_scene.instance()
			add_child(unit)
			unit.global_position = pos
			unit.color = color
			_units[pos] = unit
