class_name InfoEntity
extends Control

@export var entity:Entity

@onready var label = $RichTextLabel

var hp: String = ""
var body_state: String = ""
var invulnerability_state: String = ""
var hands_state: String = ""

func _ready() -> void:
	entity.damage_taken.connect(update_hp)
	entity.body_state_machine.state_changed.connect(update_body_state)
	entity.invulnerability_state_machine.state_changed.connect(update_invulnerability_state)
	entity.hands_state_machine.state_changed.connect(update_hands_state)
	
	hp = str(entity.max_hp)
	body_state = entity.body_state_machine.current_state.name
	invulnerability_state = entity.invulnerability_state_machine.current_state.name
	hands_state = entity.hands_state_machine.current_state.name
	update_text()


func _physics_process(_delta: float) -> void:
	pass


func update_text() -> void:
	var text: String = ""
	text += "HP: " + hp
	text +=  "\nBody: " + body_state
	text +=  "\nInvul: " + invulnerability_state
	text +=  "\nHands: " + hands_state
	label.clear()
	label.append_text(text)


func update_hp(_damage: float) -> void:
	hp = str(entity.hp)
	update_text()


func update_body_state(new_state: State) -> void:
	body_state = new_state.name
	update_text()


func update_invulnerability_state(new_state: State) -> void:
	invulnerability_state = new_state.name
	update_text()


func update_hands_state(new_state: State) -> void:
	hands_state = new_state.name
	update_text()
