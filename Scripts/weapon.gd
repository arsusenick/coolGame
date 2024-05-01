extends Area2D

@export var damage: int
@export var projectile_speed: int
@export var projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showStats():
	print("dmg = " + str(damage) + " speed = " + str(projectile_speed)+ " ") 


func _on_body_entered(body):
	pass # Replace with function body.
