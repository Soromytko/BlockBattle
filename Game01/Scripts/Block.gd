class_name Block extends CharacterBody2D

@export var health : float = 1

func take_damage(value : float = 1):
	health -= value
	if health <= 0:
		queue_free()
