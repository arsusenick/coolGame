extends Node2D


@export var bullet_scene: PackedScene


func _on_player_shoot(pos, dir, dmg):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	bullet.damage = dmg
	bullet.add_to_group("bullets")
