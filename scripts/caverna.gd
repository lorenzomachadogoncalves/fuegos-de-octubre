extends Node2D

@export var chave_dialogo: String = ""

const _DIALOGO_INTRO := [
	"Hm... você realmente entrou aqui.",
	"Estas cavernas são os últimos lugares onde ainda existe cor neste mundo... e também alguma lógica.",
	"Lá dentro, você vai encontrar um terminal. Ele guarda um fragmento de lógica junto com uma cor perdida.",
	"Se você resolver os enigmas que ele propõe, essa cor poderá ser devolvida ao mundo lá de fora.",
	"Mas cuidado: cada resposta errada faz o mundo ficar um pouco mais escuro.",
	"Com três erros... bem, vamos dizer que o escuro não volta mais. E você recomeça do zero.",
	"Então pense com calma. A lógica é sua melhor aliada aqui dentro.",
	"Boa sorte. Você vai precisar.",
]

const _DIALOGOS := {
	"caverna_azul": [
		"Bem-vindo à Caverna Azul!",
		"Aqui você vai aprender sobre a NEGAÇÃO.",
		"A negação usa o símbolo ¬ e inverte o valor de uma afirmação.",
		"Se P é FALSO, então ¬P é VERDADEIRO. Se P é VERDADEIRO, então ¬P é FALSO.",
		"Exemplo: P = 'O sol é azul.' Isso é falso... então ¬P é verdadeiro!",
		"Agora resolva o desafio do totem usando o que aprendeu!",
	],
	"caverna_verde": [
		"Bem-vindo à Caverna Verde!",
		"Aqui você vai aprender sobre o OU lógico.",
		"O OU usa o símbolo ∨ e conecta duas afirmações.",
		"O resultado é VERDADEIRO se PELO MENOS UMA das afirmações for verdadeira.",
		"Exemplo: 'Gatos voam ∨ Peixes nadam.' Gatos não voam (falso), mas peixes nadam (verdadeiro)... então o resultado é verdadeiro!",
		"Agora resolva o desafio do totem usando o que aprendeu!",
	],
	"caverna_vermelha": [
		"Bem-vindo à Caverna Vermelha!",
		"Aqui você vai aprender sobre o E lógico.",
		"O E usa o símbolo ∧ e conecta duas afirmações.",
		"O resultado só é VERDADEIRO se AS DUAS afirmações forem verdadeiras ao mesmo tempo.",
		"Exemplo: 'O céu é azul ∧ a grama é verde.' As duas são verdadeiras... então o resultado é verdadeiro!",
		"Agora resolva o desafio do totem usando o que aprendeu!",
	],
}

func _ready():
	if not Global.dialogos_vistos.get("intro_caverna", false):
		$DialogBox.terminou.connect(_intro_vista)
		$DialogBox.mostrar(_DIALOGO_INTRO)
	else:
		_mostrar_dialogo_operador()

func _intro_vista():
	Global.dialogos_vistos["intro_caverna"] = true
	$DialogBox.terminou.disconnect(_intro_vista)
	_mostrar_dialogo_operador()

func _mostrar_dialogo_operador():
	if chave_dialogo == "" or Global.dialogos_vistos.get(chave_dialogo, false):
		return
	var falas: Array = _DIALOGOS.get(chave_dialogo, [])
	if falas.is_empty():
		return
	$DialogBox.terminou.connect(_dialogo_visto)
	$DialogBox.mostrar(falas)

func _dialogo_visto():
	Global.dialogos_vistos[chave_dialogo] = true
