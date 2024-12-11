extends Area2D

var enemyCount = 0

@export var doors: Array[Door] = []
@export var entranceDoor: Door

func _ready():
	pass

func on_body_entered(body):
	if body.name == "Skeleton":
		enemyCount += 1
		print("Found Enemy (%s)" % enemyCount)
	if body.name == "Player":
		entranceDoor.animator.play("appear")
		print("Found Player")

func on_body_exited(body):
	if body.name == "Skeleton":
		enemyCount -= 1
		print("Lost Enemy (%s)" % enemyCount)
	if enemyCount == 0:
		for door in doors:
			door.on_room_cleared()
		entranceDoor.on_room_cleared()