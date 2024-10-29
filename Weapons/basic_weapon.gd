extends "res://Weapons/weapon.gd"

@export var attackSpeed: int
@export var accuracy: int
@export var weaponType: String = "basic_weapon"
@export var weaponName: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_weapon_type():
	return weaponType
	
func get_weapon_name():
	return weaponName
