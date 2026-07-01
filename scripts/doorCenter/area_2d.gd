extends Area2D

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var door = get_parent()
			if Global.tem_flor_para_entregar and "caverna" in door.next_scene:
				var dialog = get_tree().current_scene.get_node_or_null("DialogBox")
				if dialog:
					dialog.mostrar([
						"Você está carregando uma flor... ela pertence ao totem principal.",
						"Entregue a flor antes de entrar em outra caverna.",
					])
				return
			var player = get_tree().get_first_node_in_group("player")
			player.move_to_door(door, $CollisionShape2D.global_position.x)
