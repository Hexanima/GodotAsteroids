extends CharacterBody2D

const SPEED = 300.0
const ROTATION_SPEED = 5

func calc_velocity():
	var vec = Vector2(0,-1).rotated(rotation)
	return vec

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		rotation -= ROTATION_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("forward"):
		print("ACCELERATING")
		velocity += calc_velocity() * SPEED * delta
	velocity -= velocity * delta * 0.5
	print(velocity)
	move_and_slide()
