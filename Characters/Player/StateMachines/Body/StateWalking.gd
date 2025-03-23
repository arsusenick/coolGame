extends State


func enter():
	animationPlayer.play("Body/walk")


func exit():
	animationPlayer.stop()


func _update(_delta:float):
	animationPlayer.speed_scale = 1 + character.velocity.length() / character.movement_speed
