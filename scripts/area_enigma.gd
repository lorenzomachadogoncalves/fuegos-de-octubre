extends Area2D

@export var riddle_box: Node2D
@export var cor: String = "azul"

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if _ja_completado():
			return
		var player = get_tree().get_first_node_in_group("player")
		player.move_to_totem(self, $CollisionShape2D.global_position.x)

func abrir_desafio():
	riddle_box.recompensa = cor
	riddle_box.abrir()

func _ja_completado() -> bool:
	match cor:
		"azul": return Global.flor_azul
		"verde": return Global.flor_verde
		"vermelha": return Global.flor_vermelha
	return false
