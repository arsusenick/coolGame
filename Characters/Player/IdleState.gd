extends State
class_name PlayerIdleState


func enter():
	animationPlayer.play("idle")


func exit():
	animationPlayer.stop()


func update(_delta:float):
	if character.velocity.round() != Vector2.ZERO:
		transitioned.emit("walking")