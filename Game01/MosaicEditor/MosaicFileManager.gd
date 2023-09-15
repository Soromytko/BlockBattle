class_name MosaicFileManager

class MosaicUnit:
	var position : Vector2:
		get: return position
	var color : Color:
		get: return color
	func _init(position : Vector2, color : Color):
		self.position = position
		self.color = color
		

static func save_to_file(units : Array[MosaicUnit], path : String = "res://mosaic_editor_scene.mes"):
	var file = FileAccess.open(path, FileAccess.WRITE)
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
	var units : Array[MosaicUnit]
	var file = FileAccess.open(path, FileAccess.READ)
	if file.is_open():
		while file.get_position() < file.get_length():
			var pos : Vector2 = Vector2(file.get_float(), file.get_float())
			var color : Color = Color(file.get_float(), file.get_float(), file.get_float(), 1)
			var unit : MosaicUnit = MosaicUnit.new(pos, color)
			units.append(unit)
		file.close()
	return units
