extends Node2D
@onready var timer = $Timer
@onready var cam_control = $CamControl
@onready var camera: Camera2D = $CamControl/Camera

const SHIP = preload("res://scenes/ship.tscn")
const DEATH_SOUND = preload("res://scenes/self_deleting_sound.tscn")

@export var invincibility_time: float = 3
var current_timer: float
var is_invincible = true

signal ship_shooting(dir: float, pos: Vector2)
signal camera_info_updated(camera_pos: Vector2, viewport_size: Vector2)
var ship
const PLAYER_DIED: AudioStreamMP3 = preload("res://assets/sounds/PLAYER_DIED.mp3")

func _ready():
	new_ship()
	
func new_ship():
	is_invincible = true
	current_timer = invincibility_time
	ship = SHIP.instantiate()
	ship.connect("on_shoot", _on_ship_shoot)
	ship.connect("collision", _on_ship_collision)
	add_child(ship)
	enable_invins()

func disable_invins():
	is_invincible = false
	if (ship != null):
		ship.regular_anim()

func enable_invins():
	is_invincible = true
	ship.invincibility_anim()
	
func play_death_sound():
	var death_sound = DEATH_SOUND.instantiate()
	death_sound.stream = PLAYER_DIED
	death_sound.position = ship.position
	add_child(death_sound)

func _process(_delta: float):
	if (current_timer > 0 && is_invincible):
		current_timer -= _delta
	else:
		disable_invins()

	if (Input.is_action_just_pressed("shoot")):
		print(get_viewport_rect())

var last_camera_pos: Vector2

func _physics_process(_delta: float):
	cam_control.position = ship.position if ship != null else Vector2.ZERO
	
	# Solo emitir si la cámara se movió lo suficiente
	if ship != null and last_camera_pos.distance_to(camera.global_position) > 10:
		var viewport = camera.get_viewport_rect()
		camera_info_updated.emit(camera.global_position, viewport.size)
		last_camera_pos = camera.global_position

func _on_ship_shoot(dir: float, pos: Vector2):
	ship_shooting.emit(dir, pos)
	
func get_screen_center() -> Vector2:
	var viewport = camera.get_viewport_rect()
	
	print("-------------------------------------------------------")
	print(viewport.position) # TOP-LEFT
	print(viewport.get_center())
	print(camera.global_position)
	print("-------------------------------------------------------")
	
	return camera.get_screen_center_position()

func _on_ship_collision():
	if (!is_invincible):
		play_death_sound()
		ship.queue_free()
		camera.position_smoothing_speed = 2
		timer.start()

func _on_timer_timeout():
	new_ship()
	camera.position_smoothing_speed = 10
