extends Node
class_name FiniteStateMachine

var states: Dictionary = {}
var current_state: State
@export var initial_state: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(change_state)

	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _physics_process(delta):
	if current_state:
		current_state.update(delta)


func change_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())

	if !new_state:
		print("Error: Attempt to change to non-existent state: " + new_state_name)
		return

	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
