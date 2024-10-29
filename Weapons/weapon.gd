extends Area2D

@export var damage: int
@export var projectile_speed: int
@export var projectile: PackedScene
var animState = "stop"


# Called when the node enters the scene tree for the first time.
func _ready():
	$weapon/button_sprite/button.play(animState)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showStats():
	print("dmg = " + str(damage) + " speed = " + str(projectile_speed)+ " ") 


func _on_body_entered(body):
	if body.name == "Player":
		animState = "button"
		$weapon/button_sprite/button.play(animState)


func _on_body_exited(body):
	if body.name == "Player":
		animState = "stop"
		$weapon/button_sprite/button.play(animState)

func getDamage():
	return damage

