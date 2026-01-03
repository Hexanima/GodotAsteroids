extends Node2D
@onready var projectile_handler = $ProjectileHandler
@onready var ship_handler = $ShipHandler
@onready var asteroid_handler = $AsteroidHandler

func _on_ship_handler_ship_shooting(direction, pos_param):
	projectile_handler.shoot_projectile(direction, pos_param)

func _ready():
	# Conectar nueva señal de cámara
	ship_handler.connect("camera_info_updated", _on_camera_info_updated)

func _on_camera_info_updated(camera_pos: Vector2, viewport_size: Vector2):
	# Reenviar info al asteroid handler
	asteroid_handler.update_camera_info(camera_pos, viewport_size)
