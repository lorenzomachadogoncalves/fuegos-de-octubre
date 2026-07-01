extends Node2D

func animar(textura: Texture2D, origem: Vector2, destino: Vector2, totemToDelete: Area2D) -> void:
	$Sprite2D.texture = textura
	global_position = origem
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", destino, 3)
	await tween.finished
	if totemToDelete:
		var fade = create_tween()
		fade.tween_property(totemToDelete, "modulate:a", 0.0, 2)
		await fade.finished
		totemToDelete.hide()
		totemToDelete.modulate.a = 1.0
	queue_free()
