extends Node2D
@onready var projectile_handler = $ProjectileHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ship_on_shoot(direction, position):
	projectile_handler.shoot_projectile(direction, position)
