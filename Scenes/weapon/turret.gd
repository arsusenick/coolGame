extends Node2D

@onready var timer = $Timer
@export var turret_angel: float = 0
@export var turret_speed: float = 0.2
@export var bullet_speed: int = 400
@export var turret_bullet: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = turret_speed
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _shoot():
	var bullet = turret_bullet.instantiate()
	var rad = turret_angel * 0.0175
	$Sprite2D.rotation = rad + 90 * 0.0175
	bullet.speed = bullet_speed
	bullet.position = position
	bullet.direction = Vector2(cos(rad), sin(rad))
	get_tree().current_scene.add_child(bullet)

func _on_timer_timeout():
	_shoot()
