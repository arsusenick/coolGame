extends Projectile



func _ready() -> void:
	animation_player.play("spin")


func _process(delta: float) -> void:
	pass


func _physics_process(_delta) -> void:
	velocity = velocity.lerp(move_direction * speed, 1)
	move_and_slide()


func _on_hitbox_body_entered(body) -> void:
	if body.visibility_layer == 0:
		free()
	if body is EntityPlayer:
		body.take_damage(damage)
