class_name Block extends StaticBody2D

export(float) var health = 1
export(PackedScene) var particles_scene

export(Color) var color : Color setget set_color, get_color
func set_color(value : Color):
	color = value
	$Polygon2D.color = color
func get_color(): return color


func _ready():
	$Polygon2D.color = color


func take_damage(value : float = 1):
	health -= value
	if health <= 0:
		_die()
	
func kill():
	take_damage(health)	


func _die():
	queue_free()
	if not particles_scene:
		return
	var particles = particles_scene.instance()
	get_parent().add_child(particles)
	particles.global_position = global_position
	var part : CPUParticles2D = particles.get_child(0)
	part.emitting = true
#	Automatically remove the particle node
	get_tree().create_timer(part.lifetime, false).timeout.connect(particles.queue_free.bind())
	
