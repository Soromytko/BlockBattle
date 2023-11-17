class_name PhysicsMosaicSandbox extends MosaicSandbox


func apply_force_to_unit(unit : PhysicsMosaicUnit, force : Vector2, radius : float):
	var force_magnitude : float = force.length()
	var unit_position : Vector2 = unit.global_position
	var unit_index : Vector2 = get_unit_index(unit_position)
	var start_index : Vector2 = get_unit_index(unit_position - Vector2.ONE * radius)
	var end_index : Vector2 = get_unit_index(unit_position + Vector2.ONE * radius)
	for x in range(start_index.x, end_index.x, 1):
		for y in range(start_index.y, end_index.y, 1):
			var current_unit_index : Vector2 = Vector2(x, y)
			if _units.has(current_unit_index):
				var current_unit : PhysicsMosaicUnit = _units[current_unit_index]
				var current_unit_position : Vector2 = current_unit.global_position
				var current_unit_direction : Vector2 = current_unit_position - unit_position
				var current_unit_magnitude : float = current_unit_direction.length()
				if current_unit_magnitude <= radius:
					var angle : float = force.angle_to(current_unit_direction)
					if abs(angle) < PI * 0.5:
						var current_force_magnitude : float = (1 - current_unit_magnitude / radius)
						current_force_magnitude *= force_magnitude * cos(angle)
						var current_force : Vector2 = Vector2(cos(angle), sin(angle)) * current_force_magnitude
#						TODO: Debug
#						current_unit.color = Color(current_force_magnitude / force_magnitude, 0, 0, 1)
						current_unit.apply_force(current_force)
						
						
#TODO: It's very expensive
func apply_force_to_unit_recursively(unit : PhysicsMosaicUnit, force : Vector2):
	var damping : float = 0.7
	if force.length() < damping:
		return
	var unit_position : Vector2 = unit.global_position
	var unit_index : Vector2 = get_unit_index(unit_position)
	for current_unit_index in _get_adjacent_unit_indexes(unit_index):
		if _units.has(current_unit_index):
			var current_unit : PhysicsMosaicUnit = _units[current_unit_index]
			var current_unit_position : Vector2 = unit_index_to_global_position(current_unit_index)
			var current_unit_direction : Vector2 = (current_unit_position - unit_position).normalized()
			var angle : float = force.angle_to(current_unit_direction)
#			The counterclockwise rotation is negative (the specificity of Godot)
			angle = abs(angle)
			if angle < deg2rad(80):
				var current_force : Vector2 = current_unit_direction * cos(angle) * force.length()
				current_unit.apply_force(current_force * damping)
				apply_force_to_unit_recursively(current_unit, current_force * damping)
					
					
func _get_adjacent_unit_indexes(unit_index : Vector2):
	var is_even : int = 1 if int(unit_index.y) % 2 == 0 else 0
	var is_odd : int = 1 - is_even
	return [
		unit_index + Vector2.LEFT,
		unit_index + Vector2.UP + Vector2.LEFT * is_even,
		unit_index + Vector2.DOWN + Vector2.LEFT * is_even,
		unit_index + Vector2.RIGHT,
		unit_index + Vector2.UP + Vector2.RIGHT  * is_odd,
		unit_index + Vector2.DOWN + Vector2.RIGHT * is_odd,
	]
	
	
