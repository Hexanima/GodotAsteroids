extends RigidBody2D

class_name Asteroid

const SELF_DELETING_SOUND = preload("res://scenes/self_deleting_sound.tscn")
const ASTEROID_EXPLODE = preload("res://assets/sounds/ASTEROID_EXPLODE.mp3")

const ASTEROID_TEXTURE = preload("res://assets/sprites/asteroid.png")
const EASTER_TEXTURE = preload("res://assets/sprites/asteroid-easter.png")

const MAX_ROTATION_SPEED: float = 10.0
const MIN_SPEED: float = 20.0
const MAX_SPEED: float = 150.0

var _rotation_speed: float = randf_range(0 - MAX_ROTATION_SPEED, MAX_ROTATION_SPEED)
var _movement_speed: float = randf_range(MIN_SPEED, MAX_SPEED)

var _size: int

signal collision()
signal collision_spawn(pos: Vector2, size: int)

@export_range(0.0, 1.0) var easter_probability: float = 0.2

@onready var asteroid: Sprite2D = $Asteroid
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_of_area2d: CollisionShape2D = $Area2D/CollisionShape2D

func handle_size() -> void:
	asteroid.scale = Vector2(_size * (1.0 / 3.0), _size * (1.0 / 3.0))
	collision_shape_2d.scale = Vector2(_size * (1.0 / 3.0), _size * (1.0 / 3.0))
	collision_shape_2d_of_area2d.scale = Vector2(_size * (1.0 / 3.0), _size * (1.0 / 3.0))

func calc_direction():
	var vec = Vector2(0, -1).rotated(rotation)
	return vec
	
func handle_movement() -> void:
	linear_velocity = calc_direction() * _movement_speed

func handle_death():
	var parent = get_parent()
	var death_sound = SELF_DELETING_SOUND.instantiate()
	death_sound.stream = ASTEROID_EXPLODE
	death_sound.position = position
	parent.add_child(death_sound)
	queue_free()
	
func _ready() -> void:
	rotation_degrees = randf_range(0, 360)

	if randf() < easter_probability && _size < 3:
		asteroid.texture = EASTER_TEXTURE
	else:
		asteroid.texture = ASTEROID_TEXTURE

	handle_size()
	handle_movement()

func _physics_process(delta: float) -> void:
	rotation += _rotation_speed * delta
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is not Asteroid && body.collision != null && body != self):
		body.collision.emit()
		collision.emit()

func _on_life_span_timeout() -> void:
	queue_free()

func _on_collision() -> void:
	if (_size > 1):
		collision_spawn.emit(global_position, _size - 1)
	handle_death()
