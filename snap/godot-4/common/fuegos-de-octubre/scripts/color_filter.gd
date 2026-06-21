extends CanvasLayer

func _ready() -> void:
	refresh()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_R: toggle_color("red")
			KEY_G: toggle_color("green")
			KEY_B: toggle_color("blue")

func toggle_color(color: String) -> void:
	Global.color_channels[color] = 0.0 if Global.color_channels[color] > 0.0 else 1.0
	refresh()

func refresh() -> void:
	var mat = $ColorRect.material
	mat.set_shader_parameter("red_amount", Global.color_channels["red"])
	mat.set_shader_parameter("green_amount", Global.color_channels["green"])
	mat.set_shader_parameter("blue_amount", Global.color_channels["blue"])

func unlock_color(color: String) -> void:
	Global.color_channels[color] = 1.0
	refresh()
