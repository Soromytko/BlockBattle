class_name PhysicsMosaicUnit extends MosaicUnit
tool

onready var _springBody : SpringBody = $SpringBody

		
func apply_force(force : Vector2, damping : float = 1.0):
	_springBody.apply_force(force * damping)
	
	
