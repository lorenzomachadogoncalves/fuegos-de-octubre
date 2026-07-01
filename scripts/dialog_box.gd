extends Node2D

signal terminou
signal escolha_feita(indice: int)

@export var som_proximo: AudioStream

var _falas: Array = []
var _indice: int = 0

@onready var _painel = $CanvasLayer/Panel
@onready var _blocker = $CanvasLayer/Blocker
@onready var _texto = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel
@onready var _btn = $CanvasLayer/Panel/MarginContainer/VBoxContainer/HBoxContainer/BtnProximo
@onready var _audio = $CanvasLayer/AudioStreamPlayer
@onready var _choice_container = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ChoiceContainer
@onready var _btn_opcao1 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ChoiceContainer/BtnOpcao1
@onready var _btn_opcao2 = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ChoiceContainer/BtnOpcao2

func _ready():
	_painel.hide()
	_blocker.hide()
	_choice_container.hide()
	_audio.stream = som_proximo
	_btn.pressed.connect(_avancar)
	_btn_opcao1.pressed.connect(func(): _on_escolha(0))
	_btn_opcao2.pressed.connect(func(): _on_escolha(1))

func mostrar(falas: Array):
	if falas.is_empty():
		return
	_falas = falas
	_indice = 0
	_texto.text = _falas[_indice]
	_blocker.show()
	_painel.show()
	_bloquear_player(true)

func mostrar_escolha(texto: String, opcoes: Array) -> void:
	_texto.text = texto
	_blocker.show()
	_painel.show()
	_bloquear_player(true)
	_btn.hide()
	_btn_opcao1.text = opcoes[0]
	_btn_opcao2.text = opcoes[1]
	_choice_container.show()

func _on_escolha(indice: int) -> void:
	_choice_container.hide()
	_btn.show()
	_painel.hide()
	_blocker.hide()
	_bloquear_player(false)
	escolha_feita.emit(indice)

func _avancar():
	if _audio.stream:
		_audio.play()
	_indice += 1
	if _indice >= _falas.size():
		_painel.hide()
		_blocker.hide()
		_bloquear_player(false)
		terminou.emit()
		return
	_texto.text = _falas[_indice]

func _bloquear_player(bloquear: bool):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.can_move = not bloquear
