extends Node2D

var item_atual = ""
var enigmas = []
var resposta = ""
@onready var texto = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel
@onready var btn1 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button
@onready var btn2 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button2
@onready var btn3 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button3
@onready var btn4 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button4
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button.pressed.connect(func(): _on_resposta_pressed($Button))
	$CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button2.pressed.connect(func(): _on_resposta_pressed($Button2))
	$CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button3.pressed.connect(func(): _on_resposta_pressed($Button3))
	$CanvasLayer/Panel/MarginContainer/VBoxContainer/CenterContainer/GridContainer/Button4.pressed.connect(func(): _on_resposta_pressed($Button4))
	$CanvasLayer.hide()
	enigmas = carregar_enigmas()
	gerar_enigmas()

func _on_resposta_pressed(botao: Button):
	if botao.text == resposta:
		fechar()

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
	$CanvasLayer.hide()

	var player = get_tree().get_first_node_in_group("player")
	player.can_move = true
	
