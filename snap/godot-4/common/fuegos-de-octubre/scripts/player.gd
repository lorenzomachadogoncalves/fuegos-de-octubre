extends CharacterBody2D

@export var speed = 150

var target_x
var ground_y

func _ready():

	target_x = global_position.x
	ground_y = global_position.y

	$AnimatedSprite2D.play("idle")

func _physics_process(delta):

	if Input.is_action_just_pressed("click"):

		target_x = get_global_mouse_position().x

	var direction = target_x - global_position.x

	if abs(direction) > 5:

		velocity.x = sign(direction) * speed
		velocity.y = 0

		move_and_slide()

		global_position.y = ground_y

		if $AnimatedSprite2D.animation != "walk":
			$AnimatedSprite2D.play("walk")

		$AnimatedSprite2D.flip_h = velocity.x > 0

	else:

		velocity = Vector2.ZERO

		global_position.y = ground_y

		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")
