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

func _ready():
	_musica = AudioStreamPlayer.new()
	add_child(_musica)

func tocar_musica(stream: AudioStream):
	if _musica.stream == stream and _musica.playing:
		return
	_musica.stream = stream
	_musica.play()

func parar_musica():
	_musica.stop()

func set_volume(db: float):
	_musica.volume_db = db
