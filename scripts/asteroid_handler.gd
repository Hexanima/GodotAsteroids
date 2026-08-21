extends Node2D
const ASTEROID = preload("res://scenes/asteroid.tscn")

# Variables para almacenar info de cámara
var current_camera_pos: Vector2
var current_viewport_size: Vector2
@export var spawn_timer: float = 5
var current_time: float

func _ready() -> void:
	current_time = spawn_timer

func _process(_delta: float) -> void:
	current_time -= _delta

	if (current_time <= 0):
		current_time = spawn_timer
		spawn_asteroid_relative_to_camera()

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
			spawn_pos = current_camera_pos + Vector2(-current_viewport_size.x / 2, randf_range(-current_viewport_size.y / 2, current_viewport_size.y / 2))
			target_direction = randf_range(-30, 30) # Hacia la derecha
		1: # Derecha
			spawn_pos = current_camera_pos + Vector2(current_viewport_size.x / 2, randf_range(-current_viewport_size.y / 2, current_viewport_size.y / 2))
			target_direction = randf_range(150, 210) # Hacia la izquierda
		2: # Arriba
			spawn_pos = current_camera_pos + Vector2(randf_range(-current_viewport_size.x / 2, current_viewport_size.x / 2), -current_viewport_size.y / 2)
			target_direction = randf_range(60, 120) # Hacia abajo
		3: # Abajo
			spawn_pos = current_camera_pos + Vector2(randf_range(-current_viewport_size.x / 2, current_viewport_size.x / 2), current_viewport_size.y / 2)
			target_direction = randf_range(240, 300) # Hacia arriba
		
	summon_asteroid(spawn_pos, target_direction, 3)

func on_asteroid_break_spawn(pos: Vector2, size: int):
	for i in randi_range(1, 3):
		summon_asteroid(pos, randf_range(0, 360), size)

func summon_asteroid(start_pos: Vector2, rotation_degs: float, size: int):
	var new_asteroid = ASTEROID.instantiate()
	new_asteroid._size = size
	new_asteroid.position = start_pos
	new_asteroid.rotation_degrees = rotation_degs
	new_asteroid.connect("collision_spawn", on_asteroid_break_spawn)
	add_child(new_asteroid)
	new_asteroid.handle_movement()
	new_asteroid.handle_size()
