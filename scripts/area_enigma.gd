extends Area2D

@export var riddle_box: Node2D

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		riddle_box.recompensa = "azul"
		riddle_box.abrir()
