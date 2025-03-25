extends State


func enter():
	animationPlayer.play("idle")


func exit():
	animationPlayer.stop()


func _update(_delta:float):
	pass