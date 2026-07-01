extends Node2D

@export var chave_dialogo: String = ""

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
	if chave_dialogo == "" or Global.dialogos_vistos.get(chave_dialogo, false):
		return
	var falas: Array = _DIALOGOS.get(chave_dialogo, [])
	if falas.is_empty():
		return
	$DialogBox.terminou.connect(_dialogo_visto)
	$DialogBox.mostrar(falas)

func _dialogo_visto():
	Global.dialogos_vistos[chave_dialogo] = true
