extends Node2D
const ASTEROID = preload("res://scenes/asteroid.tscn")

# Variables para almacenar info de cámara
var current_camera_pos: Vector2
var current_viewport_size: Vector2

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("debug_spawn_asteroid")):
		spawn_asteroid_relative_to_camera()

# Método para recibir info de cámara desde game.gd
func update_camera_info(camera_pos: Vector2, viewport_size: Vector2):
	current_camera_pos = camera_pos
	current_viewport_size = viewport_size

func spawn_asteroid_relative_to_camera():
	# Calcular posición relativa a la cámara
	var spawn_side = randi() % 4 # 0=izq, 1=der, 2=arriba, 3=abajo
	var spawn_pos: Vector2
	var target_direction: float
		
	match spawn_side:
		0: # Izquierda
			spawn_pos = current_camera_pos + Vector2(-current_viewport_size.x / 2 - 100, randf_range(-current_viewport_size.y / 2, current_viewport_size.y / 2))
			target_direction = randf_range(-30, 30) # Hacia la derecha
		1: # Derecha
			spawn_pos = current_camera_pos + Vector2(current_viewport_size.x / 2 + 100, randf_range(-current_viewport_size.y / 2, current_viewport_size.y / 2))
			target_direction = randf_range(150, 210) # Hacia la izquierda
		2: # Arriba
			spawn_pos = current_camera_pos + Vector2(randf_range(-current_viewport_size.x / 2, current_viewport_size.x / 2), -current_viewport_size.y / 2 - 100)
			target_direction = randf_range(60, 120) # Hacia abajo
		3: # Abajo
			spawn_pos = current_camera_pos + Vector2(randf_range(-current_viewport_size.x / 2, current_viewport_size.x / 2), current_viewport_size.y / 2 + 100)
			target_direction = randf_range(240, 300) # Hacia arriba
		
	summon_asteroid(spawn_pos, target_direction)

func summon_asteroid(start_pos: Vector2, rotation_degs: float):
	var new_asteroid = ASTEROID.instantiate()
	new_asteroid.position = start_pos
	new_asteroid.rotation_degrees = rotation_degs
	new_asteroid.handle_movement()
	add_child(new_asteroid)
