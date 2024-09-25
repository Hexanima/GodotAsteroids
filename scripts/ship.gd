extends CharacterBody2D

@onready var sprite = $Sprite
@onready var propulsion_audio = $PropulsionAudio

const SPEED = 300.0
const ROTATION_SPEED = 5

func calc_velocity():
	var vec = Vector2(0,-1).rotated(rotation)
	return vec

func handle_movement(delta: float):
	if Input.is_action_pressed("left"):
		rotation -= ROTATION_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("forward"):
		print("ACCELERATING")
		velocity += calc_velocity() * SPEED * delta
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

func _physics_process(delta):
	handle_movement(delta)
	handle_anim()
	handle_audio()
	print(velocity)
	move_and_slide()
