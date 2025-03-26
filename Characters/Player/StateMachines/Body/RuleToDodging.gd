extends Transition

var has_dodged: bool = false

func can_transition(_character: Entity) -> bool:
	if has_dodged:
		has_dodged = false
		return true
	return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("controls_dash"):
		has_dodged = true
	elif event.is_action_released("controls_dash"):
		has_dodged = false

