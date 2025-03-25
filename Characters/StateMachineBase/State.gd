extends Node
class_name State

#NOTE This is the State base-class, all states inherits this logic

@export var character: Entity
@export var animationPlayer: AnimationPlayer

var transitions: Array[Transition] = [] 

signal transitioned(new_state: State)

func _ready():
	# Собираем все переходы из дочерних узлов
	for child in get_children():
		if child is Transition:
			transitions.append(child)
	
	# Сортируем переходы по приоритету
	transitions.sort_custom(func(a, b): return a.priority > b.priority)


func update(delta: float):
	# Проверяем правила перехода
	for transition in transitions:
		if transition.can_transition(character):
			transitioned.emit(transition.target_state)
			# print("Unknown StateMachine: Transitioned from: ", name, " to: ", transition.target_state.name)
			return

	# Выполняем логику состояния
	_update(delta)


# Переопределяемые методы для конкретных состояний
func enter():
	pass

func exit():
	pass

func _update(_delta:float):
	pass
