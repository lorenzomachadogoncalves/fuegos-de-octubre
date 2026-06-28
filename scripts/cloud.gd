extends Node2D

@export var speed: float = 20.0
@export var reset_x: float = -200.0
@export var start_x: float = 1300.0

func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x < reset_x:
		position.x = start_x
