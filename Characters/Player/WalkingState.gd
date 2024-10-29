extends State
class_name PlayerWalkingState


func enter():
	animationPlayer.play("walk")


func exit():
	animationPlayer.stop()


func update(_delta:float):
	animationPlayer.speed_scale = 1 + character.velocity.length() / character.speed

	if character.velocity.round() == Vector2.ZERO:
		transitioned.emit("idle")