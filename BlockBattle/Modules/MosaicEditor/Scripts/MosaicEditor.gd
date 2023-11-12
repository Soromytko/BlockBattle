extends Node2D

export(NodePath) var camera_path
export(NodePath) var mosaic_sandbox_path

onready var _camera : Camera2D = get_node(camera_path)
onready var _mosaic_sandbox : MosaicSandbox = get_node(mosaic_sandbox_path)
var _brush_unit : MosaicUnit


func _ready():
	_brush_unit = _mosaic_sandbox.get_unit_scene().instance()
	_brush_unit.radius = _mosaic_sandbox.get_unit_radius()
	add_child(_brush_unit)
	_brush_unit.color = Color.black
	
	
func _input(event):
	if Input.is_key_pressed(KEY_S):
		_save()
	elif Input.is_key_pressed(KEY_L):
		_load()
	elif Input.is_key_pressed(KEY_R):
		_brush_unit.color = Color.red
		_brush_unit.color = Color.darkred
	elif Input.is_key_pressed(KEY_G):
		_brush_unit.color = Color.darkolivegreen
	elif Input.is_key_pressed(KEY_B):
		_brush_unit.color = Color.blue
	elif Input.is_key_pressed(KEY_Y):
		_brush_unit.color = Color.yellow
	elif Input.is_key_pressed(KEY_P):
		_brush_unit.color = Color.pink
	elif Input.is_key_pressed(KEY_O):
		_brush_unit.color = Color.orange
	elif Input.is_key_pressed(KEY_W):
		_brush_unit.color = Color.white


func _process(delta):
	var mouse_pos = _camera.get_local_mouse_position()
	mouse_pos = get_global_mouse_position()
	var unit_pos = _mosaic_sandbox.get_nearest_unit_position(mouse_pos)
	_brush_unit.global_position = unit_pos
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var unit : MosaicUnit = _mosaic_sandbox.create_unit_by_global_position(unit_pos)
		if unit != null:
			unit.color = _brush_unit.color
	elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
		_mosaic_sandbox.delete_unit_by_global_position(unit_pos)
		
		
func _save():
	MosaicFileManager.save_as_scene(_mosaic_sandbox)
	
	
func _load():
	remove_child(_mosaic_sandbox)
	_mosaic_sandbox.queue_free()
	_mosaic_sandbox = MosaicFileManager.load_as_scene()
	add_child(_mosaic_sandbox)
	_brush_unit.radius = _mosaic_sandbox.get_unit_radius()
	
