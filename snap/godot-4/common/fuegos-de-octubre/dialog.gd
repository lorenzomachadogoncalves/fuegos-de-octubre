extends CanvasLayer

@onready var texto = $Panel/RichTextLabel

var falas = [
	"[center]Você finalmente acordou.[/center]",
	"[center]Há muito tempo estou observando você.[/center]",
	"[center]Siga para o norte e encontrará as respostas.[/center]"
]

var indice = 0

func _ready():
	texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto.vertical_alignment = HORIZONTAL_ALIGNMENT_CENTER
	print("dialogo iniciando")
	iniciar_dialogo()

func iniciar_dialogo():
	indice = 0
	texto.text = falas[indice]
	$Panel.show()

func avancar():
	indice += 1

	if indice >= falas.size():
		$Panel.hide()
		return

	texto.text = falas[indice]

func _input(event):
	if event.is_action_pressed("ui_accept") and $Panel.visible:
		avancar()
