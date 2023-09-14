class_name Block extends StaticBody2D

@export var health : float = 1

func set_color(color : Color):
	$Polygon2D.color = color
	

func take_damage(value : float = 1):
	health -= value
	if health <= 0:
		queue_free()
