extends RigidBody2D

signal collision()
const SELF_DELETING_SOUND = preload("res://scenes/self_deleting_sound.tscn")
const ASTEROID_EXPLODE = preload("res://assets/sounds/ASTEROID_EXPLODE.mp3")

const MAX_ROTATION_SPEED: float = 10.0

var _rotation_speed: float = randf_range(0 - MAX_ROTATION_SPEED,MAX_ROTATION_SPEED)

func _physics_process(delta: float) -> void:
	rotation += _rotation_speed * delta

func _on_collision() -> void:
	var parent = get_parent()
	var death_sound = SELF_DELETING_SOUND.instantiate()
	death_sound.stream = ASTEROID_EXPLODE
	death_sound.position = position
	parent.add_child(death_sound)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.collision != null && body != self):
		body.collision.emit()
		collision.emit()
