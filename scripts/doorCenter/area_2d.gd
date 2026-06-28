extends Area2D

@export var next_scene : String
@export var target_door_name : String

func _input_event(viewport, event, shape_idx):

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var player = get_tree().get_first_node_in_group("player")
			player.move_to_door(self, $CollisionShape2D.global_position.x)
