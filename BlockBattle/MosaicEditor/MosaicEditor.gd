extends Node2D

export(NodePath) var camera_path
export(float) var radius : float = 10
export(PackedScene) var hexagon_scene : PackedScene

onready var _camera : Camera2D = get_node(camera_path)
onready var _mosaic_root : Node2D = $MosaicRoot

var _brush_unit : Node2D
var _units = {}
var _brush_color : Color


func _ready():
	_brush_unit = hexagon_scene.instance()
	add_child(_brush_unit)


func _input(event):
	if Input.is_key_pressed(KEY_S):
		_save_as_scene()
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
	var hex_pos = _to_hex_pos(mouse_pos)
	_brush_unit.global_position = hex_pos
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if !_units.has(hex_pos):
			create_unit(hex_pos, _brush_color)
			

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
	

func create_unit(position : Vector2, color : Color):
	var unit = hexagon_scene.instance()
	_mosaic_root.add_child(unit)
	unit.owner = _mosaic_root
	unit.global_position = position
	unit.color = color
	_units[position] = unit


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
			create_unit(pos, color)
			
			
func _save_as_scene():
	_save()
#	# Create the objects.
#	var node = Node2D.new()
#	var rigid = RigidBody2D.new()
#	var collision = CollisionShape2D.new()
#
#	# Create the object hierarchy.
#	rigid.add_child(collision)
#	node.add_child(rigid)
#
#	# Change owner of `rigid`, but not of `collision`.
#	rigid.owner = node
#
#	var scene = PackedScene.new()
#	# Only `node` and `rigid` are now packed.
#	var result = scene.pack(node)
#	if result == OK:
#		var error = ResourceSaver.save("res://name.scn", scene)  # Or "user://..."
#		if error != OK:
#			push_error("An error occurred while saving the scene to disk.")
#
	var scene : PackedScene = PackedScene.new()
	var result = scene.pack(_mosaic_root)
	if 	result == OK:
		var error = ResourceSaver.save("res://Scenes/Levels/Level0.tscn", scene)
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
