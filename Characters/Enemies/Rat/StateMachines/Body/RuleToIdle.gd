extends Transition

func can_transition(character: Entity) -> bool:
    return character.velocity.round() == Vector2.ZERO
