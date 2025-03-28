class_name Weapon
extends Node

@export var display_name: String = self.name

@export var icon: Texture2D
@export var animation_player: AnimationPlayer
@export var projectile: Projectile
@export var player: EntityPlayer

@export var damage: float = 1.0


func attack() -> void:
	pass
