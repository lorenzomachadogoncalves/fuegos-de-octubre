extends Area2D

func _ready():
	_restaurar_flores()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if _tem_flores_para_colocar():
			var player = get_tree().get_first_node_in_group("player")
			player.move_to_totem(self, $CollisionShape2D.global_position.x)

func abrir_desafio():
	_colocar_flores()

func _tem_flores_para_colocar() -> bool:
	return (Global.flor_azul     and Global.color_channels["blue"]  < 1.0) or \
		   (Global.flor_verde    and Global.color_channels["green"] < 1.0) or \
		   (Global.flor_vermelha and Global.color_channels["red"]   < 1.0)

func _colocar_flores():
	var cena = get_tree().current_scene
	var color_filter = cena.get_node_or_null("ColorFilter")
	if not color_filter:
		return
	if Global.flor_azul and Global.color_channels["blue"] < 1.0:
		color_filter.unlock_color("blue")
		cena.get_node("FlorAzul").show()
	if Global.flor_verde and Global.color_channels["green"] < 1.0:
		color_filter.unlock_color("green")
		cena.get_node("FlorVerde").show()
	if Global.flor_vermelha and Global.color_channels["red"] < 1.0:
		color_filter.unlock_color("red")
		cena.get_node("FlorVermelha").show()

func _restaurar_flores():
	var cena = get_tree().current_scene
	if Global.color_channels["blue"]  >= 1.0: cena.get_node("FlorAzul").show()
	if Global.color_channels["green"] >= 1.0: cena.get_node("FlorVerde").show()
	if Global.color_channels["red"]   >= 1.0: cena.get_node("FlorVermelha").show()
