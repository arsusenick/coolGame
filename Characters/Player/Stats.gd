extends Node

@export var player_health = {"SH":6,"LNR":0,"DNR":0}
var order: Array[String] = ["SH","DNR","LNR"]
@export var player_speed: int = 50
@export var max_red_health: int = 6
var player_weapon = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_health(dmg: int):
	if player_health["SH"] != 0:
		player_health["SH"] = player_health["SH"] - dmg
		print(str(player_health))
