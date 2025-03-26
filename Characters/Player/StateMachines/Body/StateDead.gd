extends State


func enter():
	animationPlayer.play("Body/die")

func exit():
	animationPlayer.stop()

func _update(_delta:float):
	pass

