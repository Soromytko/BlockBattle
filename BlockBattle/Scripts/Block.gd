class_name Block extends PhysicsMosaicUnit
tool

export(float) var health = 1
export(PackedScene) var particles_scene

func take_damage(value : float = 1):
	health -= value
	if health <= 0:
		_die()
		
		
func kill():
	take_damage(health)	


func _die():
	return
#	TODO: Dad design 
	var sandbox : MosaicSandbox = get_parent()
	sandbox.delete_unit_by_global_position(global_position)
	
	if not particles_scene:
		return
	var particles = particles_scene.instance()
	get_parent().add_child(particles)
	particles.global_position = global_position
	var part : CPUParticles2D = particles.get_child(0)
	part.emitting = true
#	Automatically remove the particle node
	get_tree().create_timer(part.lifetime, false).timeout.connect(particles.queue_free.bind())
	
