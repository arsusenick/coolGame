extends EntityPlayer
class_name Player


var health = {"RED":6,"CURSED":0,"POISONED":0}
var health_order: Array[String] = ["RED", "CURSED", "POISONED"]
var max_health: int = 6

@export var dash_mult = 10

@onready var user_interface = $UserInterface	


func _ready():
	user_interface.set_health_icon(health, health_order)


func _physics_process(delta: float):
	super(delta)
	base_attack()
	$Label.set_text(str(state_machine.current_state))


func base_attack() -> void:
	if get_node_or_null("Bottle") == null:
		return
	if Input.is_action_just_pressed("controls_base_attack"):
		var mouse_pos = get_local_mouse_position()
		$Bottle.shoot(mouse_pos)

#TODO Пересмотреть работу с таймером и избавиться от лишней ноды.

## Subtracts dmg from health, 
## updates UI health bar._add_global_constant and 
## runs immortality timer and animation.
func get_damage(dmg: int):
	if health["RED"] != 0:
		health["RED"] = health["RED"] - dmg

	user_interface.set_health_icon(health, health_order)

	$immortalityTimer.start()
	$Character/immortalityAnim.play("immortality")

	set_collision_layer_value(2, false)

	
## Stops immortality and its animation.
func _on_immortality_timer_timeout():
	$Character/immortalityAnim.stop()
	set_collision_layer_value(2, true)
