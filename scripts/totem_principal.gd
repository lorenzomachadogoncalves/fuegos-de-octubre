extends Area2D

var _processando := false

func _ready():
	_restaurar_flores()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if not _processando and _tem_flores_para_colocar():
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

	_processando = true
	var player = get_tree().get_first_node_in_group("player")
	player.can_move = false

	const TEXTURAS := {
		"blue":  "res://assets/objects/blue-flower.png",
		"green": "res://assets/objects/green-flower.png",
		"red":   "res://assets/objects/red-flower.png",
	}

	var pendentes := []
	if Global.flor_azul     and Global.color_channels["blue"]  < 1.0:
		pendentes.append(["blue",  "FlorAzul"])
		Global.flor_azul = false
	if Global.flor_verde    and Global.color_channels["green"] < 1.0:
		pendentes.append(["green", "FlorVerde"])
		Global.flor_verde = false
	if Global.flor_vermelha and Global.color_channels["red"]   < 1.0:
		pendentes.append(["red",   "FlorVermelha"])
		Global.flor_vermelha = false

	for par in pendentes:
		var cor: String     = par[0]
		var nome_no: String = par[1]
		var flor_node := cena.get_node(nome_no) as Node2D
		var textura          = load(TEXTURAS[cor]) as Texture2D

		var flor_animada = preload("res://cenas_reutilizaveis/FlorAnimada.tscn").instantiate()
		cena.add_child(flor_animada)
		var origem := flor_node.global_position + Vector2(0, -160)
		await flor_animada.animar(textura, origem, flor_node.global_position, null)

		flor_node.show()
		color_filter.unlock_color_animado(cor, 10)

	await get_tree().create_timer(1.8).timeout

	var dialog = cena.get_node_or_null("DialogBox")
	if dialog:
		dialog.terminou.connect(func():
			player.can_move = true
			Global.tem_flor_para_entregar = false
			_processando = false
		, CONNECT_ONE_SHOT)
		dialog.mostrar([
			"A cor voltou... pelo menos um pouco.",
			"O totem absorveu o que você trouxe. O mundo respira novamente, por enquanto.",
			"Se ainda houver cavernas por explorar, o caminho está aberto.",
		])
	else:
		player.can_move = true
		Global.tem_flor_para_entregar = false
		_processando = false

func _restaurar_flores():
	var cena = get_tree().current_scene
	if Global.color_channels["blue"]  >= 1.0: cena.get_node("FlorAzul").show()
	if Global.color_channels["green"] >= 1.0: cena.get_node("FlorVerde").show()
	if Global.color_channels["red"]   >= 1.0: cena.get_node("FlorVermelha").show()
