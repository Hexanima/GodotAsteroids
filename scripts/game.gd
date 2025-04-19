extends Node2D
@onready var projectile_handler = $ProjectileHandler

func _on_ship_handler_ship_shooting(direction, pos_param):
	projectile_handler.shoot_projectile(direction, pos_param)
