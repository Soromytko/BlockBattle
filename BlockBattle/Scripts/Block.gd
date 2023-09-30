class_name Block extends StaticBody2D

@export var health : float = 1
@export var particles_scene : PackedScene

func set_color(color : Color):
	$Polygon2D.color = color
	

func take_damage(value : float = 1):
	health -= value
	if health <= 0:
		_die()
	
func kill():
	take_damage(health)	


func _die():
	var particles = particles_scene.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	var part : CPUParticles2D = particles.get_child(0)
	part.emitting = true
#	Automatically remove the particle node
	get_tree().create_timer(part.lifetime, false).timeout.connect(particles.queue_free.bind())
	queue_free()
