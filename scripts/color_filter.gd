extends CanvasLayer

func _ready() -> void:
	refresh()


func refresh() -> void:
	var mat = $ColorRect.material
	mat.set_shader_parameter("red_amount", Global.color_channels["red"])
	mat.set_shader_parameter("green_amount", Global.color_channels["green"])
	mat.set_shader_parameter("blue_amount", Global.color_channels["blue"])

func unlock_color(color: String) -> void:
	Global.color_channels[color] = 1.0
	refresh()

func unlock_color_animado(color: String, duracao: float = 1.5) -> void:
	var tween = create_tween()
	tween.tween_method(_set_canal.bind(color), 0.0, 1.0, duracao)
	await tween.finished

func _set_canal(valor: float, color: String) -> void:
	Global.color_channels[color] = valor
	refresh()
