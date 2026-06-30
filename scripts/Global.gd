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

var _musica: AudioStreamPlayer
var _stream_atual: AudioStream = null

func _ready():
	_musica = AudioStreamPlayer.new()
	add_child(_musica)
	_musica.finished.connect(func(): _musica.play())

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
