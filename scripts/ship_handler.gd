extends Node2D
@onready var timer = $Timer
@onready var cam_control = $CamControl
@onready var camera: Camera2D = $CamControl/Camera

const SHIP = preload("res://scenes/ship.tscn")
const DEATH_SOUND = preload("res://scenes/self_deleting_sound.tscn")

signal ship_shooting(dir: float, pos: Vector2)
var ship
const PLAYER_DIED: AudioStreamMP3 = preload("res://assets/sounds/PLAYER_DIED.mp3")
func _ready():
	new_ship()
	
func new_ship():
	ship = SHIP.instantiate()
	ship.connect("on_shoot", _on_ship_shoot)
	ship.connect("collision", _on_ship_collision)
	add_child(ship)
	
func play_death_sound():
	var death_sound = DEATH_SOUND.instantiate()
	death_sound.stream = PLAYER_DIED
	death_sound.position = ship.position
	add_child(death_sound)

func _physics_process(delta: float):
	cam_control.position = ship.position if ship != null else Vector2.ZERO

func _on_ship_shoot(dir: float, pos: Vector2):
	ship_shooting.emit(dir, pos)
	get_screen_center()
	
func get_screen_center() -> Vector2:
	var viewporttt = camera.get_viewport_rect()
	
	print("-------------------------------------------------------")
	print(viewporttt.position) # TOP-LEFT
	print(viewporttt.get_center())
	print(camera.global_position)
	print("-------------------------------------------------------")
	
	return camera.get_screen_center_position()

func _on_ship_collision():
	play_death_sound()
	ship.queue_free()
	camera.position_smoothing_speed = 2
	timer.start()

func _on_timer_timeout():
	new_ship()
	camera.position_smoothing_speed = 10	
