extends StaticBody2D

signal collision()

func _ready() -> void:
	connect("collision",_on_collision)
	
func _on_collision():
	queue_free()
