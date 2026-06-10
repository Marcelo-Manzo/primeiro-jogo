extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

const DASH_SPEED = 300
var is_dashing = false
var can_dash = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump. (Mudado de "ui_accept" para "pular" ou "ui_accept" com a tecla W configurada)
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# Mudado de "ui_left" e "ui_right" para suas ações customizadas
	
	# obtem a direção de entrada: -1,0,1
	var direction := Input.get_axis("esquerda", "direita")
	# mudar direção
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Animações
	if is_dashing:
		animated_sprite.play("dash")
	elif not is_on_floor():
		animated_sprite.play("jump")
	elif direction == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
	
	# Movimento
	
	if Input.is_action_just_pressed("dash") and can_dash and is_on_floor():
		is_dashing = true
		can_dash = false
		dash_timer.start()
		dash_cooldown_timer.start()
	
	if direction:
		if is_dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_dash_timer_timeout() -> void:
	is_dashing = false


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
