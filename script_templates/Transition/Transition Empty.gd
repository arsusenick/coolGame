extends Transition

# meta-name: Empty Transition
# meta-description: A transition that does nothing
# meta-default: true

func can_transition(_character: Entity) -> bool:
    return false
