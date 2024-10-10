extends CharacterBody2D

@onready var sprite = $Sprite
@onready var propulsion_audio = $PropulsionAudio

const SPEED = 300.0
const ROTATION_SPEED = 5

signal on_shoot(direction: float, position: Vector2)

func calc_direction():
	var vec = Vector2(0,-1).rotated(rotation)
	return vec

func handle_movement(delta: float):
	if Input.is_action_pressed("left"):
		rotation -= ROTATION_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("forward"):
		velocity += calc_direction() * SPEED * delta
	velocity -= velocity * delta * 0.5

func handle_anim():
	if Input.is_action_pressed("forward"):
		sprite.animation = "thrust"
	else:
		sprite.animation = "idle"

func handle_audio():
	if Input.is_action_just_pressed("forward"):
		propulsion_audio.play()
	if Input.is_action_just_released("forward"):
		propulsion_audio.stop()

func handle_shoot():
	if Input.is_action_just_pressed("shoot"):
		on_shoot.emit(rotation,global_position + calc_direction() * 32)

func _physics_process(delta):
	handle_movement(delta)
	handle_anim()
	handle_audio()
	handle_shoot()
	move_and_slide()
