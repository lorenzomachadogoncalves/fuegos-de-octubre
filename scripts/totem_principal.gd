extends Area2D

var _processando := false

const _DIALOGO_ANUNCIO_FINAL := [
	"...",
	"Então você trouxe as três flores. Achei que nunca chegaria até aqui.",
	"Mas o mundo ainda não está completo. Cores não bastam — é preciso provar que você entende o que as gerou.",
	"Negação. Conjunção. Disjunção. Inferência. Decomposição.",
	"O terminal final está diante de você. Três respostas corretas. Sem mais chances.",
	"Mostre que valeu a pena.",
]

const _DIALOGO_VITORIA := [
	"...",
	"Impossível. Você realmente fez isso.",
	"As cores voltaram. O mundo respira de novo.",
	"Talvez você seja digno de habitá-lo, afinal.",
]

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

	var tudo_completo = (
		(Global.flor_azul     or Global.color_channels["blue"]  > 0.0) and
		(Global.flor_verde    or Global.color_channels["green"] > 0.0) and
		(Global.flor_vermelha or Global.color_channels["red"]   > 0.0)
	)

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

	Global.tem_flor_para_entregar = false
	var dialog = cena.get_node_or_null("DialogBox")

	if dialog:
		if tudo_completo and not Global.dialogos_vistos.get("desafio_final_concluido", false):
			dialog.terminou.connect(_iniciar_desafio_final.bind(player), CONNECT_ONE_SHOT)
			dialog.mostrar(_DIALOGO_ANUNCIO_FINAL)
		else:
			dialog.terminou.connect(func():
				player.can_move = true
				_processando = false
			, CONNECT_ONE_SHOT)
			dialog.mostrar([
				"A cor voltou... pelo menos um pouco.",
				"O totem absorveu o que você trouxe. O mundo respira novamente, por enquanto.",
				"Se ainda houver cavernas por explorar, o caminho está aberto.",
			])
	else:
		player.can_move = true
		_processando = false

func _iniciar_desafio_final(player: Node) -> void:
	var cena = get_tree().current_scene
	var riddle_box = cena.get_node_or_null("RiddleBox")
	if riddle_box == null:
		player.can_move = true
		_processando = false
		return
	var caminho = "res://enigmas-final-dedutivo.json" if Global.game_mode == "dedutivo" \
				  else "res://enigmas-final.json"
	riddle_box.caminho_enigmas = caminho
	riddle_box.recompensa = "final"
	riddle_box.totem = null
	riddle_box.acertos_necessarios = 3
	riddle_box.desafio_final_concluido.connect(
		_on_desafio_final_concluido.bind(player), CONNECT_ONE_SHOT
	)
	riddle_box.abrir()

func _on_desafio_final_concluido(player: Node) -> void:
	var cena = get_tree().current_scene
	var dialog = cena.get_node_or_null("DialogBox")
	Global.dialogos_vistos["desafio_final_concluido"] = true
	if dialog:
		dialog.terminou.connect(_finalizar_jogo.bind(player), CONNECT_ONE_SHOT)
		dialog.mostrar(_DIALOGO_VITORIA)
	else:
		await _finalizar_jogo(player)

func _finalizar_jogo(player: Node) -> void:
	player.can_move = false
	var cena = get_tree().current_scene
	var fade = cena.get_node_or_null("FadeInFinal")
	if fade:
		var anim = fade.get_node_or_null("AnimationPlayer")
		if anim:
			anim.play("final_fade_in")
			await anim.animation_finished
	await get_tree().create_timer(0.6).timeout
	_processando = false
	Global.reiniciar_completo()

func _restaurar_flores():
	var cena = get_tree().current_scene
	var color_filter = cena.get_node_or_null("ColorFilter")
	for entry in [["blue", "FlorAzul"], ["green", "FlorVerde"], ["red", "FlorVermelha"]]:
		var cor: String = entry[0]
		var nome: String = entry[1]
		if Global.color_channels[cor] > 0.0:
			if color_filter and Global.color_channels[cor] < 1.0:
				color_filter.unlock_color(cor)
			cena.get_node(nome).show()
