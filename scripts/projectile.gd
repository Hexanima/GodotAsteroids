extends AnimatableBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer

const SPEED: float = 750

func calc_direction():
	var vec = Vector2(0,-1).rotated(rotation)
	return vec

func handle_movement(delta: float):
	return calc_direction() * SPEED * delta

func _physics_process(delta):
	move_and_collide(handle_movement(delta))

func _on_audio_finished():
	queue_free()
