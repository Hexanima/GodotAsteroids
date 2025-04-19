extends RigidBody2D

signal collision()

func _on_collision() -> void:
	queue_free()
