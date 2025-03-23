extends Transition


func can_transition(_character: Entity) -> bool:
	return source_state.dodge_timer >= source_state.dodge_duration

