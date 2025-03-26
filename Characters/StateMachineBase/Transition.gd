extends Node
class_name Transition

@export var target_state: State
@export var priority: int = 1

var source_state: State

func _ready():
    # Получаем ссылку на родительское состояние
    source_state = get_parent()

# Функция, определяющая возможность перехода
func can_transition(_character: Entity) -> bool:
    return false  # Переопределяется в конкретных переходах 