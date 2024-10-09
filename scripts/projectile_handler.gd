extends Node2D
const PROJECTILE = preload("res://scenes/projectile.tscn")

func shoot_projectile(dir: float, posParam: Vector2):
	var newProjectile = PROJECTILE.instantiate()
	newProjectile.position = posParam
	newProjectile.rotate(dir)
	add_child(newProjectile)
