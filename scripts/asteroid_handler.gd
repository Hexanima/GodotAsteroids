extends Node2D
const ASTEROID = preload("res://scenes/asteroid.tscn")

func spawn_asteroid()->void:
	var new_asteroid = ASTEROID.instantiate()
	add_child(new_asteroid)

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug_spawn_asteroid")):
		spawn_asteroid()
