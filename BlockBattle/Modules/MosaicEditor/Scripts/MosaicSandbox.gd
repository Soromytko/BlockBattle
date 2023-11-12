class_name MosaicSandbox extends Node2D

export(PackedScene) var unit_scene : PackedScene
export(float) var unit_radius : float = 5

var _units : Dictionary
var _even_grid : MosaicSandboxGrid
var _odd_grid : MosaicSandboxGrid


func get_units() -> Dictionary:
	return _units
	

func get_unit_scene() -> PackedScene:
	return unit_scene
	

func get_unit_radius() -> float:
	return unit_radius


func _ready():
	var cell_size : Vector2 = Vector2(sqrt(3), 3) * unit_radius
	var odd_grid_offset : Vector2 = Vector2(sqrt(3) / 2, 1.5) * unit_radius
	_even_grid = MosaicSandboxGrid.new(cell_size)
	_odd_grid = MosaicSandboxGrid.new(cell_size, odd_grid_offset)
	for child in get_children():
		if child is MosaicUnit:
			var unit_index = get_unit_index(child.global_position)
			if !_units.has(unit_index):
				_units[unit_index] = child
	
	
func create_unit_by_global_position(position : Vector2) -> MosaicUnit:
	var unit_index : Vector2 = get_unit_index(position)
	if !_units.has(unit_index):
		var unit : MosaicUnit = unit_scene.instance()
		add_child(unit)
		unit.owner = self
		unit.global_position = unit_index_to_global_position(unit_index)
		unit.radius = unit_radius
		_units[unit_index] = unit
		return unit
	return null
	
	
func delete_unit_by_global_position(position : Vector2) -> bool:
	var unit_index : Vector2 = get_unit_index(position)
	if _units.has(unit_index):
		var unit = _units[unit_index]
		unit.queue_free()
		return _units.erase(unit_index)
	return false
	
	
func get_unit_by_global_position(position : Vector2):
	var unit_index : Vector2 = get_unit_index(position)
	if _units.has(unit_index):
		return _units[unit_index]
	return null
	
	
func get_nearest_unit_position(position : Vector2) -> Vector2:
	var unit_index = get_unit_index(position)
	return unit_index_to_global_position(unit_index)
	
	
func get_unit_index(position : Vector2):
#	Find the nearest one in the even grid
	var index_in_even_grid : Vector2 = _even_grid.get_nearest_cell_index(position)
	var position_in_even_grid : Vector2 = _even_grid.cell_index_to_global_position(index_in_even_grid)
	
#	Find the nearest one in the odd grid
	var index_in_odd_grid : Vector2 = _odd_grid.get_nearest_cell_index(position)
	var position_in_odd_grid : Vector2 = _odd_grid.cell_index_to_global_position(index_in_odd_grid)
	
#	Determine the preferred unit index
	var dist_to_even : float = position.distance_to(position_in_even_grid)
	var dist_to_odd : float = position.distance_to(position_in_odd_grid)
	var is_even : bool = dist_to_even < dist_to_odd
	if is_even:
		return Vector2(index_in_even_grid.x, index_in_even_grid.y * 2)
	return Vector2(index_in_odd_grid.x, index_in_odd_grid.y * 2 + 1)
	
	
func unit_index_to_global_position(unit_index : Vector2) -> Vector2:
	var is_even : bool = int(unit_index.y) % 2 == 0
	var grid : MosaicSandboxGrid = _even_grid if is_even else _odd_grid
	var x : float = unit_index.x
	var y : float = unit_index.y if is_even else unit_index.y - 1
	return grid.cell_index_to_global_position(Vector2(x, y / 2))
	
	
	
