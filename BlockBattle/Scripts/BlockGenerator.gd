class_name BlockGenerator extends Node2D

export(Vector2) var block_field_size : Vector2
export(Vector2) var block_size : Vector2
export(PackedScene) var block_scene : PackedScene

func _ready():
	var mosaic_units = MosaicFileManager.load_from_file()
	for mosaic_unit in mosaic_units:
		var block : Block = block_scene.instance()
		block.global_position = mosaic_unit.position
		block.set_color(mosaic_unit.color)
		add_child(block)
#		call_deferred("add_child", block)


