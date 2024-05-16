extends Node

@export var player_health = {"SH":5,"LNR":1,"DNR":2}
var order: Array[String] = ["SH","DNR","LNR"]
@export var player_speed: int = 50
var player_weapon = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_health():
	player_health["SH"] = 6


