extends CharacterBody2D

@export var speed = 150

var target_x
var ground_y
var target_door = null
var door_clicked = false

func _ready():

	target_x = global_position.x
	ground_y = global_position.y

	$AnimatedSprite2D.play("idle")

func _physics_process(delta):

	if Input.is_action_just_pressed("click"):
		if not door_clicked:
			print("nao clicou na porta")
			target_door = null
			target_x = get_global_mouse_position().x
	var direction = target_x - global_position.x
	if abs(direction) > 5:
		walk(direction)
	else:
		arrived_at_destination()
	door_clicked = false

func arrived_at_destination():
	velocity = Vector2.ZERO
	global_position.y = ground_y
	if $AnimatedSprite2D.animation != "idle":
		$AnimatedSprite2D.play("idle")
	if target_door:
		vai_para_a_cena_da_porta()

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
	get_tree().change_scene_to_file(target_door.next_scene)
	target_door = null

func move_to_door(door, x):
	door_clicked = true
	print("indo para a porta")
	target_x = x
	target_door = door
