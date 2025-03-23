extends State


func enter():
	animationPlayer.play("Body/idle")


func exit():
	animationPlayer.stop()


func _update(_delta:float):
	pass