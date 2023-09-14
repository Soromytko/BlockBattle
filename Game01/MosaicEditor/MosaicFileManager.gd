class_name MosaicFileManager

class MosaicUnitData:
	var color : Color:
		get: return color
	func _init(color : Color):
		self.color = color
		

static func save_to_file(units : Dictionary, path : String = "res://mosaic_editor_scene.mes"):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file.is_open():
		for pos in units:
			var unit : MosaicUnitData = units[pos]
			file.store_float(pos.x)
			file.store_float(pos.y)
			file.store_float(unit.color.r)
			file.store_float(unit.color.g)
			file.store_float(unit.color.b)
		file.close()


static func load_from_file(path : String = "res://mosaic_editor_scene.mes"):
	var units = {}
	var file = FileAccess.open(path, FileAccess.READ)
	if file.is_open():
		while file.get_position() < file.get_length():
			var pos : Vector2 = Vector2(file.get_float(), file.get_float())
			var color : Color = Color(file.get_float(), file.get_float(), file.get_float(), 1)
			var unit = MosaicUnitData.new(color)
			units[pos] = unit
		file.close()
	return units
