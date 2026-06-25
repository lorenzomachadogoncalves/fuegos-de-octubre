extends CanvasLayer

func fade_and_change_scene(scene_path):

	$ColorRect.visible = true

	$AnimationPlayer.play("fade_in")

	await $AnimationPlayer.animation_finished

	get_tree().change_scene_to_file(scene_path)
