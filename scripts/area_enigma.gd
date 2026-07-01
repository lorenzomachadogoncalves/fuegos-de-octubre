extends Area2D

@export var riddle_box: Node2D
@export var cor: String = "azul"

const _DIALOGOS := {
	"caverna_azul": [
		"A negação usa o símbolo ¬ e inverte o valor de uma afirmação.",
		"Se P é FALSO, então ¬P é VERDADEIRO. Se P é VERDADEIRO, então ¬P é FALSO.",
		"Exemplo: P = 'O sol é azul.' Isso é falso... então ¬P é verdadeiro!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
	"caverna_verde": [
		"O OU usa o símbolo ∨ e conecta duas afirmações.",
		"O resultado é VERDADEIRO se PELO MENOS UMA das afirmações for verdadeira.",
		"Exemplo: 'Gatos voam ∨ Peixes nadam.' Gatos não voam (falso), mas peixes nadam (verdadeiro)... então o resultado é verdadeiro!",
		"Agora resolva o desafio do terminal usando o que aprendeu!",
	],
	"caverna_vermelha": [
		"O E usa o símbolo ∧ e conecta duas afirmações.",
		"O resultado só é VERDADEIRO se AS DUAS afirmações forem verdadeiras ao mesmo tempo.",
		"Exemplo: 'O céu é azul ∧ a grama é verde.' As duas são verdadeiras... então o resultado é verdadeiro!",
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
		dialog_box.terminou.connect(_dialogo_visto, CONNECT_ONE_SHOT)
		dialog_box.mostrar(_DIALOGOS.get(chave, []))
	else:
		riddle_box.recompensa = cor
		riddle_box.abrir()

func _dialogo_visto() -> void:
	Global.dialogos_vistos["caverna_" + cor] = true
	riddle_box.recompensa = cor
	riddle_box.abrir()

func _ja_completado() -> bool:
	match cor:
		"azul": return Global.flor_azul
		"verde": return Global.flor_verde
		"vermelha": return Global.flor_vermelha
	return false
