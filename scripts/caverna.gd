extends Node2D

@export var linhas_dialogo: PackedStringArray = []
@export var chave_dialogo: String = ""

func _ready():
	if chave_dialogo == "" or Global.dialogos_vistos.get(chave_dialogo, false):
		return
	$DialogBox.terminou.connect(_dialogo_visto)
	$DialogBox.mostrar(linhas_dialogo)

func _dialogo_visto():
	Global.dialogos_vistos[chave_dialogo] = true
