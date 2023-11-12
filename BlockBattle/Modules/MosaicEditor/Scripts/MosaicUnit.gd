class_name MosaicUnit extends StaticBody2D
tool

export(Color) var color : Color = Color.white setget set_color, get_color
export(float) var radius : float = 20 setget set_radius, get_radius

var _initial_radius : float = 20

func set_color(value : Color):
	color = value
	var sprite = get_node("Sprite")
#	Make sure the node tree is ready
	if sprite != null:
		sprite.modulate = value
#	else:
#		call_deferred("set_color", value)
	
	
func get_color() -> Color:
	return color
	
	
func set_radius(value : float):
	radius = value
	scale = Vector2.ONE * value / _initial_radius
	
	
func get_radius() -> float:
	return radius
