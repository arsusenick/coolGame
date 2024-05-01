extends Area2D

var speed: int = 500
var direction: Vector2
var damage: int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += speed * direction * delta


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.name != "TileMap":	
		print(direction)
		print(damage)
		body.get_damage(damage)
	queue_free()
