extends Transition

var is_passive: bool = false

func can_transition(_character: Entity) -> bool:
	if is_passive:
		is_passive = false
		return true
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_released("controls_base_attack"):
		is_passive = true

