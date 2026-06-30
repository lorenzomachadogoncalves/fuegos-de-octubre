extends CharacterBody2D

@export var speed = 150

var target_x
var ground_y
var target_door = null
var target_totem = null
var door_clicked = false
var totem_clicked = false
var can_move = true

func _ready():
	if Global.target_door_name != "":
		var target_door_node = get_tree().current_scene.find_child(Global.target_door_name, true, false)
		if target_door_node:
			var area = target_door_node.get_node_or_null("Area2D")
			if area:
				var shape = area.get_node_or_null("CollisionShape2D")
				if shape:
					global_position.x = shape.global_position.x
				else:
					global_position.x = target_door_node.global_position.x
			else:
				global_position.x = target_door_node.global_position.x
		Global.target_door_name = ""

	target_x = global_position.x
	ground_y = global_position.y

	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if !can_move:
		return

	if Input.is_action_just_pressed("click"):
		if not door_clicked and not totem_clicked:
			target_door = null
			target_totem = null
			target_x = get_global_mouse_position().x

	var direction = target_x - global_position.x
	if abs(direction) > 5:
		walk(direction)
	else:
		arrived_at_destination()

	door_clicked = false
	totem_clicked = false

func arrived_at_destination():
	velocity = Vector2.ZERO
	global_position.y = ground_y
	if $AnimatedSprite2D.animation != "idle":
		$AnimatedSprite2D.play("idle")
	if target_door:
		vai_para_a_cena_da_porta()
	elif target_totem:
		target_totem.abrir_desafio()
		target_totem = null

func walk(direction):
	velocity.x = sign(direction) * speed
	velocity.y = 0
	move_and_slide()
	global_position.y = ground_y
	if $AnimatedSprite2D.animation != "walk":
		$AnimatedSprite2D.play("walk")
	$AnimatedSprite2D.flip_h = velocity.x > 0

func vai_para_a_cena_da_porta():
	print("Entrando na proxima cena...")
	if target_door:
		Global.target_door_name = target_door.target_door_name
		var fade = get_tree().current_scene.get_node_or_null("FadeLayer")
		if fade:
			fade.fade_and_change_scene(target_door.next_scene)
		else:
			get_tree().change_scene_to_file(target_door.next_scene)
		target_door = null

func move_to_door(door, x):
	door_clicked = true
	target_x = x
	target_door = door
	target_totem = null

func move_to_totem(totem, x):
	totem_clicked = true
	target_x = x
	target_totem = totem
	target_door = null
