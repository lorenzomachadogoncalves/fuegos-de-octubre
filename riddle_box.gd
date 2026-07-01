extends Node2D

signal desafio_final_concluido

@export var caminho_enigmas: String = "res://enigmas.json"
var recompensa = ""
var totem: Node = null
var enigmas = []
var resposta = ""
var acertos = 0

@onready var som_acerto = $SomAcerto
@onready var som_erro = $SomErro
@onready var titulo = $CanvasLayer/Panel/MarginContainer/VBoxContainer/Label
@onready var texto = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel
@onready var btn1 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/GridContainer/Button
@onready var btn2 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/GridContainer/Button2
@onready var btn3 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/GridContainer/Button3
@onready var btn4 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/GridContainer/Button4

func _ready():
	som_acerto.stream = preload("res://assets/sounds/hit.wav")
	som_acerto.volume_db = -12.0
	som_erro.stream = preload("res://assets/sounds/error.mp3")
	som_erro.volume_db = -12.0
	btn1.pressed.connect(func(): _on_resposta_pressed(btn1))
	btn2.pressed.connect(func(): _on_resposta_pressed(btn2))
	btn3.pressed.connect(func(): _on_resposta_pressed(btn3))
	btn4.pressed.connect(func(): _on_resposta_pressed(btn4))
	$CanvasLayer.hide()
	$CanvasLayer/Control/FlorAzul.visible = Global.flor_azul
	$CanvasLayer/Control/FlorVerde.visible = Global.flor_verde
	$CanvasLayer/Control/FlorVermelha.visible = Global.flor_vermelha

func _on_resposta_pressed(botao: Button):
	if botao.text == resposta:
		som_acerto.play()
		acertos += 1
		_atualizar_titulo()
		if acertos >= 3:
			mostrar_recompensa()
		else:
			gerar_enigma()
	else:
		som_erro.play()
		Global.registrar_erro()
		gerar_enigma()

func carregar_enigmas():
	var file = FileAccess.open(caminho_enigmas, FileAccess.READ)
	if file == null:
		print("Erro ao abrir JSON")
		return []
	var json_text = file.get_as_text()
	var json = JSON.new()
	var erro = json.parse(json_text)
	if erro != OK:
		print("Erro ao interpretar JSON")
		return []
	return json.data

func gerar_enigma():
	var enigma = enigmas.pick_random()
	texto.text = str(enigma.frase)
	resposta = str(enigma.correta)
	var opcoes: Array = enigma.opcoes.duplicate()
	opcoes.shuffle()
	btn1.text = str(opcoes[0])
	btn2.text = str(opcoes[1])
	btn3.text = str(opcoes[2])
	btn4.text = str(opcoes[3])

func _atualizar_titulo():
	titulo.text = "%d / 3" % acertos

func abrir():
	enigmas = carregar_enigmas()
	acertos = 0
	titulo.text = "0 / 3"
	gerar_enigma()
	$CanvasLayer.show()
	var player = get_tree().get_first_node_in_group("player")
	player.can_move = false

func fechar():
	$CanvasLayer/Panel.hide()
	var player = get_tree().get_first_node_in_group("player")
	player.can_move = true

const _DIALOGO_RECOMPENSA := {
	"azul": [
		"...Você provou que a lógica ainda vive em alguém.",
		"A Flor Azul é sua. Ela carrega a frieza da razão — a única coisa capaz de salvar este mundo.",
		"Volte lá fora. O totem principal aguarda sua oferta.",
		"O caminho de volta está aberto. Por enquanto.",
	],
	"verde": [
		"...Hm. Não esperava isso de você.",
		"A Flor Verde é sua. Ela guarda o que resta da vida neste lugar cinzento.",
		"Volte lá fora. O totem principal precisa dela.",
		"Cada cor que você devolve é uma batalha vencida contra o vazio.",
	],
	"vermelha": [
		"...Interessante. Você realmente conseguiu.",
		"A Flor Vermelha é sua. Ela carrega o calor de tudo que ainda existe neste mundo.",
		"Volte lá fora. O totem principal está esperando por ela.",
		"Não demore. A escuridão não é paciente.",
	],
}

func mostrar_recompensa():
	$CanvasLayer/Panel.hide()

	if recompensa == "final":
		$CanvasLayer.hide()
		desafio_final_concluido.emit()
		return

	const TEXTURAS := {
		"azul":     "res://assets/objects/blue-flower.png",
		"verde":    "res://assets/objects/green-flower.png",
		"vermelha": "res://assets/objects/red-flower.png",
	}
	var textura := load(TEXTURAS[recompensa]) as Texture2D
	var jogador := get_tree().get_first_node_in_group("player")
	var origem := get_viewport().get_visible_rect().get_center()

	var flor := preload("res://cenas_reutilizaveis/FlorAnimada.tscn").instantiate()
	get_tree().current_scene.add_child(flor)
	await flor.animar(textura, origem, jogador.global_position, totem)

	match recompensa:
		"azul":
			Global.flor_azul = true
			$CanvasLayer/Control/FlorAzul.show()
		"verde":
			Global.flor_verde = true
			$CanvasLayer/Control/FlorVerde.show()
		"vermelha":
			Global.flor_vermelha = true
			$CanvasLayer/Control/FlorVermelha.show()

	var dialog_box := get_parent().get_node("DialogBox")
	dialog_box.terminou.connect(_fechar_apos_dialogo.bind(jogador), CONNECT_ONE_SHOT)
	dialog_box.mostrar(_DIALOGO_RECOMPENSA[recompensa])

func _fechar_apos_dialogo(jogador: Node) -> void:
	$CanvasLayer.hide()
	jogador.can_move = true
	Global.tem_flor_para_entregar = true
