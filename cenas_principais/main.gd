extends Node2D

func _ready() -> void:
	Global.tocar_musica(preload("res://assets/sounds/background_music.wav"))
	Global.set_volume(-30.0)
	if not Global.dialogos_vistos.get("modo_selecionado", false):
		$DialogBox.escolha_feita.connect(_on_modo_escolhido, CONNECT_ONE_SHOT)
		$DialogBox.mostrar_escolha(
			"[center]Este mundo perdeu suas cores...[/center]\n[center]Como você prefere decifrar os enigmas que o habitam?[/center]",
			["Com símbolos lógicos (¬, ∧, ∨)", "Com palavras (NÃO, E, OU)"]
		)
	elif not Global.dialogos_vistos.get("intro", false):
		_mostrar_intro()

func _on_modo_escolhido(indice: int) -> void:
	Global.game_mode = "simbolos" if indice == 0 else "dedutivo"
	Global.dialogos_vistos["modo_selecionado"] = true
	if not Global.dialogos_vistos.get("intro", false):
		_mostrar_intro()

func _mostrar_intro() -> void:
	$DialogBox.terminou.connect(_intro_vista, CONNECT_ONE_SHOT)
	$DialogBox.mostrar([
		"[center]Você finalmente acordou.[/center]",
		"[center]Há muito tempo estou observando você.[/center]",
		"[center]Nesse mundo sem cor e sem lógica,[/center]",
		"[center]você é o único que se lembra de como as coisas costumavam ser[/center]",
		"[center]Siga adiante e mais respostas você obterá.[/center]"
	])

func _intro_vista():
	Global.dialogos_vistos["intro"] = true
