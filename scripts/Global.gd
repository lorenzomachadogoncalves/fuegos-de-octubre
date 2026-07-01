extends Node

var target_door_name : String = ""

var color_channels: Dictionary = {
	"red": 0.0,
	"green": 0.0,
	"blue": 0.0,
}

var flor_azul = false
var flor_verde = false
var flor_vermelha = false

var dialogos_vistos: Dictionary = {}

var enigmas_vistos: Dictionary = {}

var game_mode: String = "simbolos"

var erros: int = 0
var tem_flor_para_entregar: bool = false

var _musica: AudioStreamPlayer
var _stream_atual: AudioStream = null
var _overlay: ColorRect
var _reset_btn: Button

func _ready():
	_musica = AudioStreamPlayer.new()
	add_child(_musica)
	_musica.finished.connect(func(): _musica.play())

	var canvas = CanvasLayer.new()
	canvas.layer = 20
	add_child(canvas)

	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(_overlay)

	_reset_btn = Button.new()
	_reset_btn.text = "⟳"
	_reset_btn.focus_mode = Control.FOCUS_NONE
	_reset_btn.tooltip_text = "Reiniciar o jogo"
	_reset_btn.add_theme_font_size_override("font_size", 28)
	_reset_btn.anchor_left = 1.0
	_reset_btn.anchor_right = 1.0
	_reset_btn.offset_left = -64
	_reset_btn.offset_right = -16
	_reset_btn.offset_top = 16
	_reset_btn.offset_bottom = 60
	canvas.add_child(_reset_btn)
	_reset_btn.pressed.connect(func(): reiniciar_completo())

	await get_tree().process_frame
	_overlay.size = get_viewport().get_visible_rect().size
	get_viewport().size_changed.connect(func():
		_overlay.size = get_viewport().get_visible_rect().size
	)

func tocar_musica(stream: AudioStream):
	if _stream_atual == stream and _musica.playing:
		return
	_stream_atual = stream
	_musica.stream = stream
	_musica.play()

func parar_musica():
	_stream_atual = null
	_musica.stop()

func set_volume(db: float):
	_musica.volume_db = db

func registrar_erro():
	erros += 1
	if erros >= 3:
		game_over()
	else:
		_atualizar_escuridao()

func _atualizar_escuridao():
	var alpha = (erros / 3.0) * 0.6
	var tween = create_tween()
	tween.tween_property(_overlay, "color", Color(0, 0, 0, alpha), 0.5)

func game_over():
	var tween = create_tween()
	tween.tween_property(_overlay, "color", Color(0, 0, 0, 1.0), 1.2)
	await tween.finished

	erros = 0
	flor_azul = false
	flor_verde = false
	flor_vermelha = false
	tem_flor_para_entregar = false
	color_channels["red"] = 0.0
	color_channels["green"] = 0.0
	color_channels["blue"] = 0.0
	enigmas_vistos.clear()

	get_tree().change_scene_to_file("res://cenas_principais/main.tscn")

	await get_tree().process_frame
	await get_tree().process_frame
	_overlay.color = Color(0, 0, 0, 0)

func reiniciar_completo():
	erros = 0
	flor_azul = false
	flor_verde = false
	flor_vermelha = false
	tem_flor_para_entregar = false
	color_channels["red"] = 0.0
	color_channels["green"] = 0.0
	color_channels["blue"] = 0.0
	enigmas_vistos.clear()
	dialogos_vistos.clear()
	game_mode = "simbolos"

	get_tree().change_scene_to_file("res://cenas_principais/main.tscn")

	await get_tree().process_frame
	await get_tree().process_frame
	_overlay.color = Color(0, 0, 0, 0)
