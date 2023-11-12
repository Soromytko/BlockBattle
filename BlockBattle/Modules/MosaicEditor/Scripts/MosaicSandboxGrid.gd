class_name MosaicSandboxGrid

var _cell_size : Vector2
var _grid_offset : Vector2


func _init(cell_size : Vector2, grid_offset : Vector2 = Vector2.ZERO):
	_cell_size = cell_size
	_grid_offset = grid_offset
	
	
func get_nearest_cell_index(position : Vector2) -> Vector2:
	var offset_pos : Vector2 = position - _grid_offset
	var half_cell_size : Vector2 = _cell_size * 0.5
	var signs : Vector2 = Vector2(sign(offset_pos.x), sign(offset_pos.y))
	
	var result = (offset_pos + half_cell_size * signs) / _cell_size
	return Vector2(int(result.x), int(result.y))
	
	
func cell_index_to_global_position(cell_index : Vector2) -> Vector2:
	return cell_index * _cell_size + _grid_offset
	
	
