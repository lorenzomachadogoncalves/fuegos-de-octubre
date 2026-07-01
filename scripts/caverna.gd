extends Node2D

@export var chave_dialogo: String = ""

const _DIALOGO_INTRO := [
	"Hm... você realmente entrou aqui.",
	"Estas cavernas são os últimos lugares onde ainda existe cor neste mundo... e também alguma lógica.",
	"Aqui dentro, você vai encontrar um terminal. Ele guarda um fragmento de lógica junto com uma cor perdida.",
	"Se você resolver os enigmas que ele propõe, essa cor poderá ser devolvida ao mundo lá de fora.",
	"Mas cuidado: cada resposta errada faz o mundo ficar um pouco mais escuro.",
	"Com três erros... bem, vamos dizer que o escuro não volta mais. E você recomeça do zero.",
	"Então pense com calma. A lógica é sua melhor aliada aqui dentro.",
	"Boa sorte. Você vai precisar.",
]

func _ready():
	if not Global.dialogos_vistos.get("intro_caverna", false):
		$DialogBox.terminou.connect(_intro_vista, CONNECT_ONE_SHOT)
		$DialogBox.mostrar(_DIALOGO_INTRO)

func _intro_vista():
	Global.dialogos_vistos["intro_caverna"] = true
