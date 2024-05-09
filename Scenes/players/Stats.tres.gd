extends "res://Scripts/Movement.gd"

signal pickUp

@export var speepy: int
@export var hp: int
var weaponName = null



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("e") and weaponName != null:
		get_weapon_stats(weaponName.getDamage())
		pickUp.emit(weaponName)

func showCurrStats():
	print("hp = "+ str(hp) + " speed = "+ str(speepy))


func _on_area_2d_area_entered(area):
	if area.get_weapon_type() == "basic_weapon":
		weaponName = area
		

func _on_area_2d_area_exited(area):
	if area.get_weapon_type() == "basic_weapon":
		weaponName = null
