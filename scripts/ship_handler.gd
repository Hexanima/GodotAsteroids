extends Node2D
@onready var timer = $Timer
@onready var cam_control = $CamControl

const SHIP = preload("res://scenes/ship.tscn")

signal ship_shooting(dir: float, pos: Vector2)
var ship

# Called when the node enters the scene tree for the first time.
func _ready():
	new_ship()
	
func new_ship():
	ship = SHIP.instantiate()
	ship.connect("on_shoot", _on_ship_shoot)
	ship.connect("collision", _on_ship_collision)
	add_child(ship)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_control.position = ship.position if ship != null else Vector2.ZERO

func _on_ship_shoot(dir: float, pos: Vector2):
	ship_shooting.emit(dir, pos)

func _on_ship_collision():
	ship.queue_free()
	cam_control.get_node("Camera").position_smoothing_speed = 2
	timer.start()


func _on_timer_timeout():
	new_ship()
	cam_control.get_node("Camera").position_smoothing_speed = 10	
