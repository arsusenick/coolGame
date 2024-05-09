extends Node2D

@export var weapons: Array[PackedScene]



# Called when the node enters the scene tree for the first time.
func _ready():
	var weaponList = weapons.size()
	print(weaponList)
	for i in 3:
		var weapon = weapons[0].instantiate()
		add_child(weapon)
		weapon.position = Vector2(608 + i * 80,400)
		weapon.damage = 10 + 10 * i
		weapon.add_to_group("weapons")
	


func _on_player_pick_up(name):
	print(name)
	name.showStats()
	remove_child(name)
	#remove_from_group("weapons")
	
