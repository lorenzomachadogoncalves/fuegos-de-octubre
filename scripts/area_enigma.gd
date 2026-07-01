extends Area2D

@export var riddle_box: Node2D
@export var cor: String = "azul"

const _DIALOGOS := {
	"caverna_vermelha": [
		"A negação usa o símbolo ¬ e inverte o valor de uma afirmação.",
		"Se P é FALSO, então ¬P é VERDADEIRO. Se P é VERDADEIRO, então ¬P é FALSO.",
		"Exemplo: P = 'O sol é azul.' Isso é falso... então ¬P é verdadeiro!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
	"caverna_verde": [
		"Dois operadores habitam este terminal: o E (∧) e o OU (∨).",
		"O E (∧): o resultado é VERDADEIRO somente se AS DUAS afirmações forem verdadeiras.",
		"O OU (∨): o resultado é VERDADEIRO se PELO MENOS UMA das afirmações for verdadeira.",
		"Exemplo E: 'O céu é azul ∧ a grama é verde.' As duas são verdadeiras... então verdadeiro!",
		"Exemplo OU: 'Gatos voam ∨ peixes nadam.' Gatos não voam, mas peixes nadam... basta uma!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
	"caverna_azul": [
		"Dois poderes lógicos habitam este terminal: a Decomposição e a Inferência.",
		"Decomposição: se 'A ∧ B' é verdadeiro, podemos concluir que A é verdadeiro E que B também é.",
		"Inferência usa o símbolo → (se...então). Se 'P → Q' é uma regra e P é verdadeiro, então Q também é.",
		"Exemplo: 'Está chovendo → A rua está molhada.' Está chovendo? Então a rua está molhada!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
}

const _DIALOGOS_DEDUTIVO := {
	"caverna_vermelha": [
		"Às vezes, negar uma ideia é a única forma de revelar a verdade.",
		"Quando algo é FALSO, dizer 'NÃO' transforma em VERDADEIRO. E vice-versa.",
		"Exemplo: 'O sol é azul.' Isso é falso... então 'NÃO é verdade que o sol é azul' é verdadeiro!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
	"caverna_verde": [
		"Dois conectivos habitam este terminal: o E e o OU.",
		"Com E: o resultado é verdadeiro só se AS DUAS afirmações forem verdadeiras ao mesmo tempo.",
		"Com OU: o resultado é verdadeiro se PELO MENOS UMA das afirmações for verdadeira.",
		"Exemplo E: 'O céu é azul E a grama é verde.' As duas são verdadeiras... então verdadeiro!",
		"Exemplo OU: 'Gatos voam OU peixes nadam.' Gatos não voam, mas peixes nadam... basta uma!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
	"caverna_azul": [
		"Dois poderes habitam este terminal: a Decomposição e o SE... ENTÃO.",
		"Decomposição: se sabemos que DUAS coisas são verdadeiras juntas, podemos concluir cada uma separadamente.",
		"SE... ENTÃO: se uma regra diz 'SE acontece A, ENTÃO acontece B', e A é verdadeiro, então B também é.",
		"Exemplo: 'SE está chovendo, ENTÃO a rua fica molhada.' Está chovendo? Então a rua está molhada!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
}

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if _ja_completado():
			return
		var player = get_tree().get_first_node_in_group("player")
		player.move_to_totem(self, $CollisionShape2D.global_position.x)

func abrir_desafio():
	var chave := "caverna_" + cor
	if not Global.dialogos_vistos.get(chave, false):
		var dialog_box = get_parent().get_node("DialogBox")
		var dialogos = _DIALOGOS_DEDUTIVO if Global.game_mode == "dedutivo" else _DIALOGOS
		dialog_box.terminou.connect(_dialogo_visto, CONNECT_ONE_SHOT)
		dialog_box.mostrar(dialogos.get(chave, []))
	else:
		_abrir_riddle()

func _dialogo_visto() -> void:
	Global.dialogos_vistos["caverna_" + cor] = true
	_abrir_riddle()

func _abrir_riddle() -> void:
	if Global.game_mode == "dedutivo":
		riddle_box.caminho_enigmas = "res://enigmas-%s-dedutivo.json" % cor
	else:
		riddle_box.caminho_enigmas = "res://enigmas-%s.json" % cor
	riddle_box.recompensa = cor
	riddle_box.totem = self
	riddle_box.acertos_necessarios = 5
	riddle_box.abrir()

func _ja_completado() -> bool:
	match cor:
		"azul": return Global.flor_azul
		"verde": return Global.flor_verde
		"vermelha": return Global.flor_vermelha
	return false
