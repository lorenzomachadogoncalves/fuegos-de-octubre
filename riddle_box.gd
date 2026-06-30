extends Node2D

var recompensa = ""
var enigmas = []
var resposta = ""
@onready var texto = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel
@onready var btn1 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button
@onready var btn2 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button2
@onready var btn3 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button3
@onready var btn4 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button4

func _ready():
	btn1.pressed.connect(func(): _on_resposta_pressed(btn1))
	btn2.pressed.connect(func(): _on_resposta_pressed(btn2))
	btn3.pressed.connect(func(): _on_resposta_pressed(btn3))
	btn4.pressed.connect(func(): _on_resposta_pressed(btn4))
	$CanvasLayer.hide()
	enigmas = carregar_enigmas()
	gerar_enigmas()
	print("Essa é a resposta " + resposta)
	$CanvasLayer/Control/FlorAzul.visible = Global.flor_azul
	$CanvasLayer/Control/FlorVerde.visible = Global.flor_verde
	$CanvasLayer/Control/FlorVermelha.visible = Global.flor_vermelha

func _on_resposta_pressed(botao: Button):
	if botao.text == resposta:
		print("respondeu")
		fechar()
		mostrar_recompensa()

func carregar_enigmas():
	var file = FileAccess.open("res://enigmas.json", FileAccess.READ)

	if file == null:
		print("Erro ao abrir JSON")
		return []

	var json_text = file.get_as_text()
	var json = JSON.new()

	var erro = json.parse(json_text)

	if erro != OK:
		print("Erro ao interpretar JSON")
		return []

	print("json carregado")
	return json.data

func gerar_enigmas():
	var enigma = enigmas.pick_random()
	texto.text = enigma.frase
	resposta = enigma.correta

func abrir():
	$CanvasLayer.show()
	var player = get_tree().get_first_node_in_group("player")
	player.can_move = false

func fechar():
	$CanvasLayer/Panel.hide()
	var player = get_tree().get_first_node_in_group("player")
	player.can_move = true

func mostrar_recompensa():
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
	await get_tree().create_timer(1.5).timeout
	$CanvasLayer.hide()
