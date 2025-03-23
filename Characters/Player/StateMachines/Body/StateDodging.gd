extends State

@onready var dodge_duration: float = animationPlayer.get_animation("Body/dodge").length
var dodge_timer: float = 0.0

func enter():
	dodge_timer = 0.0
	animationPlayer.play("Body/dodge")

func exit():
	animationPlayer.stop()

func _update(_delta:float):
	dodge_timer += _delta
