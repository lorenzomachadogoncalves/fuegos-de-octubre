extends Area2D

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var player = get_tree().get_first_node_in_group("player")
			player.move_to_door(get_parent(), $CollisionShape2D.global_position.x)
