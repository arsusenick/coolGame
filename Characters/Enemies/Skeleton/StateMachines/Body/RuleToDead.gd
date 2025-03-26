extends Transition

var is_dead: bool = false

func _ready():
	super()
	source_state.character.connect("died", self.on_died)

func on_died():
	is_dead = true

func can_transition(_character: Entity) -> bool:
	if is_dead:
		if source_state.character.hp > 0:
			is_dead = false
			return false
		return true
	return false
