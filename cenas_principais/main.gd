extends Node2D

func _ready() -> void:
	Global.tocar_musica(preload("res://assets/sounds/background_music.wav"))
	Global.set_volume(-30.0)
	if not Global.dialogos_vistos.get("intro", false):
		$DialogBox.terminou.connect(_intro_vista)
		$DialogBox.mostrar([
			"[center]Você finalmente acordou.[/center]",
			"[center]Há muito tempo estou observando você.[/center]",
			"[center]Nesse mundo sem cor e sem lógica,[/center]",
			"[center]você é o único que se lembra de como as coisas costumavam ser[/center]",
			"[center]Siga adiante e mais respostas você obterá.[/center]"
		])

func _intro_vista():
	Global.dialogos_vistos["intro"] = true
