extends Node2D

signal terminou

@export var som_proximo: AudioStream

var _falas: Array = []
var _indice: int = 0

@onready var _painel = $CanvasLayer/Panel
@onready var _blocker = $CanvasLayer/Blocker
@onready var _texto = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel
@onready var _btn = $CanvasLayer/Panel/MarginContainer/VBoxContainer/HBoxContainer/BtnProximo
@onready var _audio = $CanvasLayer/AudioStreamPlayer

func _ready():
	_painel.hide()
	_blocker.hide()
	_audio.stream = som_proximo
	_btn.pressed.connect(_avancar)

func mostrar(falas: Array):
	if falas.is_empty():
		return
	_falas = falas
	_indice = 0
	_texto.text = _falas[_indice]
	_blocker.show()
	_painel.show()
	_bloquear_player(true)

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
