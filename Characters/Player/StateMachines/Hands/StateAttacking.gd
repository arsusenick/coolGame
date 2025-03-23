extends State


func enter():
	animationPlayer.play("Hands/cast")

func exit():
	animationPlayer.stop()

func _update(_delta:float):
	pass

