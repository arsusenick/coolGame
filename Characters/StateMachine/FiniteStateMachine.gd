extends Node
class_name FiniteStateMachine

@export var character: Entity
@export var animationPlayer: AnimationPlayer

@export var initial_state: State

var states: Dictionary = {}
var current_state: State

signal state_changed(new_state: State)

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)

	if initial_state:
		initial_state.enter()
		current_state = initial_state
	else:
		print("Error: No initial state set for FiniteStateMachine")


func _physics_process(delta):
	if current_state:
		current_state.update(delta)


func _on_state_transitioned(new_state: State):
	if !states.get(new_state.name.to_lower()):
		print("Error: Attempt to change to non-existent state: " + new_state.name)
		return
	
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	state_changed.emit(current_state)


# func change_state(new_state_name: String):
	# var new_state = states.get(new_state_name.to_lower())

	# if !new_state:
	# 	print("Error: Attempt to change to non-existent state: " + new_state_name)
	# 	return

# 	if current_state:
# 		current_state.exit()
		
# 	new_state.enter()
# 	current_state = new_state
# 	state_changed.emit(current_state)
