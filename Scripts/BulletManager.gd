extends Node2D


func _on_player_shoot(pos, dir, dmg, spd, bullet_scene):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.speed = spd
	bullet.direction = dir.normalized()
	bullet.damage = dmg
	bullet.add_to_group("bullets")
