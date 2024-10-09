extends CharacterBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer

const SPEED: float = 10000

func calc_direction():
	var vec = Vector2(0,-1).rotated(rotation)
	return vec

func handle_movement(delta: float):
	velocity = calc_direction() * SPEED * sqrt(delta)

func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()

func _on_audio_finished():
	queue_free()
