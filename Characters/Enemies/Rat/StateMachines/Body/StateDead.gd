extends State


func enter():
	animationPlayer.play("die")

func exit():
	animationPlayer.stop()

func _update(_delta:float):
	pass

