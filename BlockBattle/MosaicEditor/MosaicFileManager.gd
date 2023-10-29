class_name MosaicFileManager

class MosaicUnit:
	var position : Vector2 setget set_position, get_position
	func set_position(value : Vector2): position = value
	func get_position(): return position
	var color : Color setget set_color, get_color
	func set_color(value : Color): color = value
	func get_color(): return color
	func _init(position : Vector2, color : Color):
		self.position = position
		self.color = color
		

static func save_to_file(units, path : String = "res://mosaic_editor_scene.mes"):
	var file : File = File.new()
	file.open(path, File.WRITE)
	if file.is_open():
		for unit in units:
			var pos = unit.position
			var color = unit.color
			file.store_float(pos.x)
			file.store_float(pos.y)
			file.store_float(color.r)
			file.store_float(color.g)
			file.store_float(color.b)
		file.close()


static func load_from_file(path : String = "res://mosaic_editor_scene.mes"):
	var units = []
	var file = File.new()
	file.open(path, File.READ)
	if file.is_open():
		while file.get_position() < file.get_len():
			var pos : Vector2 = Vector2(file.get_float(), file.get_float())
			var color : Color = Color(file.get_float(), file.get_float(), file.get_float(), 1)
			var unit : MosaicUnit = MosaicUnit.new(pos, color)
			units.append(unit)
		file.close()
	return units
	
	
static func save_as_scene(root : Node2D, path : String = "res://MosaicEditor/Untitled.tscn"):
	var scene : PackedScene = PackedScene.new()
	var result = scene.pack(root)
	if 	result == OK:
		var error = ResourceSaver.save(path, scene)
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
