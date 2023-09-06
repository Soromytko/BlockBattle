class_name BlockGenerator extends Node3D

@export var block_field_size : Vector2i
@export var block_size : Vector2
@export var block_scene : PackedScene

func _ready():
	var blocks = {}
	for i in 100:
		var x : float = randi_range(-block_field_size.x, block_field_size.x)
		var y : float = randi_range(-block_field_size.y, block_field_size.y)
		x *= block_size.x
		y *= block_size.y
		var pos = Vector2(x, y)
		if blocks.has(pos): continue
		var block = block_scene.instantiate()
		add_child(block)
		block.global_position = pos
		blocks[pos] = true
		


