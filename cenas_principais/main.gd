extends Node2D

func _ready() -> void:
	Global.tocar_musica(preload("res://assets/sounds/background_music.wav"))
	Global.set_volume(-30.0)
	if not Global.dialogos_vistos.get("intro", false):
		$DialogBox.terminou.connect(_intro_vista)
		$DialogBox.mostrar([
			"[center]Você finalmente acordou.[/center]",
			"[center]Há muito tempo estou observando você.[/center]",
			"[center]Siga e encontrará as respostas.[/center]"
		])

func _intro_vista():
	Global.dialogos_vistos["intro"] = true
