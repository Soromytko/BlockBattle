extends CharacterBody2D

@export var speed : float = 600.0
@export var down_action_name : String
@export var up_action_name : String


func _ready():
	var area : Area2D = $Area2D
	if !area: return
	area.body_entered.connect(_on_area_2d_body_entered)
	

func _physics_process(delta):
	var direction = Input.get_axis(down_action_name, up_action_name)
	velocity.y = -direction * speed
	move_and_slide()
	

func _on_area_2d_body_entered(body):
	return
	if body is Ball:
		var ball : Ball = body
		var direction = (Vector2(1, ball.global_position.y) - global_position).normalized()
		ball.direction = direction
		print(direction)
