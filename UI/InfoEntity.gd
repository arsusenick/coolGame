class_name InfoEntity
extends Control

@export var entity:Entity

@onready var label = $RichTextLabel

var hp: String = ""
var state: String = ""


func _ready() -> void:
	entity.damage_taken.connect(update_hp)
	entity.state_machine.state_changed.connect(update_state)
	
	hp = str(entity.max_hp)
	state = entity.state_machine.current_state.name
	update_text()


func _physics_process(delta: float) -> void:
	pass


func update_text() -> void:
	var text: String = ""
	text += "HP: " + hp
	text +=  "\nState: " + state
	
	label.clear()
	label.append_text(text)


func update_hp(amount) -> void:
	hp = str(entity.hp)
	update_text()


func update_state(new_state: State) -> void:
	state = new_state.name
	update_text()
