class_name SpringBody extends Node2D

export(NodePath) var body_path
export(float) var stiffness : float = 1 setget set_stiffness, get_stiffness
export(float) var damping : float = 3 setget set_damping, get_damping
export(float) var mass : float = 1
var velocity : Vector2 setget set_velocity, get_velocity

onready var _body : Node2D = get_node(body_path)


func set_stiffness(value : float):
	stiffness = value
	
func get_stiffness() -> float:
	return stiffness
	
func set_damping(value : float):
	damping = value
	
func get_damping() -> float:
	return damping

func set_velocity(value : Vector2):
	velocity = value
	
func get_velocity() -> Vector2:
	return velocity

func get_spring_force() -> Vector2:
	return (global_position - _body.global_position) * stiffness


func apply_force(force : Vector2):
	var acceleration : Vector2 = force / mass
	velocity += acceleration


func _physics_process(delta):
	_simulate(delta)


func _simulate(delta):
	var spring_force : Vector2 = get_spring_force()
	apply_force(spring_force)
	
	_body.global_position += velocity * delta
	
	velocity *= 1 - clamp(damping * delta, 0, 1)
	
