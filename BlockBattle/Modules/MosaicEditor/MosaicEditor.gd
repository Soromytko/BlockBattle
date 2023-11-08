extends Node2D

export(NodePath) var camera_path
export(float) var hex_radius : float = 5
	
export(PackedScene) var hexagon_scene : PackedScene

onready var _camera : Camera2D = get_node(camera_path)
onready var _mosaic_root : Node2D = $MosaicRoot

var _hex_diameter : float
var _hex_odd_row_offset : Vector2
var _brush_unit : Node2D
var _units = {}
var _brush_color : Color


class CheckData:
	var x : int
	var y : int
	var distance : float
	func _init(x : int, y : int, distance : float):
		self.x = x
		self.y = y
		self.distance = distance


func _ready():
	_brush_unit = hexagon_scene.instance()
	_brush_unit.scale = Vector2.ONE * hex_radius / 10
	add_child(_brush_unit)
	
	
func _input(event):
	if Input.is_key_pressed(KEY_S):
		_save()
	elif Input.is_key_pressed(KEY_L):
		_load()
	elif Input.is_key_pressed(KEY_R):
		_brush_color = Color.red
		_brush_color = Color.darkred
	elif Input.is_key_pressed(KEY_G):
		_brush_color = Color.darkolivegreen
	elif Input.is_key_pressed(KEY_B):
		_brush_color = Color.blue
	elif Input.is_key_pressed(KEY_Y):
		_brush_color = Color.yellow
	elif Input.is_key_pressed(KEY_P):
		_brush_color = Color.pink
	elif Input.is_key_pressed(KEY_O):
		_brush_color = Color.orange
	elif Input.is_key_pressed(KEY_W):
		_brush_color = Color.white


func _process(delta):
	var mouse_pos = _camera.get_local_mouse_position()
	mouse_pos = get_global_mouse_position()
	var hex_pos = _global_pos_to_hex_pos(mouse_pos)
	_brush_unit.global_position = hex_pos
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if !_units.has(hex_pos):
			create_unit(hex_pos, _brush_color)
			


func _global_pos_to_hex_pos(pos : Vector2):
	var hex_info = _get_hex_info_in_row_by_global_pos(pos)
	return hex_info.global_hex_pos
	return hex_info.ordinal_pos * Vector2(sqrt(3), 3) * hex_radius + hex_info.row_offset
	
	
func _get_ordinal_hex_pos_in_row(pos : Vector2) -> Vector2:
	var rounded_pos = pos
	rounded_pos.x += sqrt(3) / 2 * hex_radius * (1 if rounded_pos.x > 0 else -1)
	rounded_pos.y += hex_radius * (1 if rounded_pos.y > 0 else -1)
	var x : int = rounded_pos.x / (sqrt(3) * hex_radius)
	var y : int = rounded_pos.y / (hex_radius * 3)
	return Vector2(x, y)


func _ordinal_pos_to_global_hex_pos(ordinal_pos : Vector2) -> Vector2:
	return ordinal_pos * Vector2(sqrt(3), 3) * hex_radius
	

func _get_hex_info_in_row(pos : Vector2, is_even : bool = true, row_offset : Vector2 = Vector2.ZERO) -> Dictionary:
	var offset_pos = pos - row_offset
	var ordinal_pos = _get_ordinal_hex_pos_in_row(offset_pos)
	var hex_pos = _ordinal_pos_to_global_hex_pos(ordinal_pos) + row_offset
	return {
		ordinal_pos = ordinal_pos,
		global_hex_pos = hex_pos,
		is_even = is_even,
	}
	
func _get_hex_info_in_row_by_global_pos(pos : Vector2) -> Dictionary:
#	Find the nearest one in the even row
	var even = _get_hex_info_in_row(pos)
#	Find the nearest one in the odd row
	var odd_row_offset = Vector2(sqrt(3) / 2, 1.5) * hex_radius
	var odd = _get_hex_info_in_row(pos, false, odd_row_offset)
	
	var even_dist = even.global_hex_pos.distance_to(pos)
	var odd_dist = odd.global_hex_pos.distance_to(pos)
	return even if even_dist < odd_dist else odd
	
	
func create_unit(position : Vector2, color : Color):
	var unit = hexagon_scene.instance()
	_mosaic_root.add_child(unit)
	unit.owner = _mosaic_root
	unit.global_position = position
	unit.color = color
	unit.scale = Vector2.ONE * hex_radius / 10
	_units[position] = unit


func _save():
	var mosaic_units = []
	for pos in _units:
		var color : Color = _units[pos].color
		mosaic_units.append(MosaicFileManager.MosaicUnit.new(pos, color))
	MosaicFileManager.save_to_file(mosaic_units)
	MosaicFileManager.save_as_scene(_mosaic_root)
		
	
func _load():
	var mosaic_units = MosaicFileManager.load_from_file()
	if mosaic_units.size() > 0:
		for pos in _units: _units[pos].queue_free()
		_units.clear()
		for mosaic_unit in mosaic_units:
			var pos : Vector2 = mosaic_unit.position
			var color : Color = mosaic_unit.color
			create_unit(pos, color)
			
			
