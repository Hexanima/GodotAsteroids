extends Node2D
@onready var projectile_handler = $ProjectileHandler

func _on_ship_handler_ship_shooting(direction, position):
	projectile_handler.shoot_projectile(direction, position)
