extends Transition

var is_attacking: bool = false

func can_transition(_character: Entity) -> bool:
	if is_attacking:
		is_attacking = false
		return true
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("controls_base_attack"):
		is_attacking = true
		
