extends CharacterBody2D
class_name Player


var health = {"RED":6,"CURSED":0,"POISONED":0}
var health_order: Array[String] = ["RED","CURSED", "POISONED"]
var max_health: int = 6

@export var speed = 100
@export var friction = 0.3
@export var acceleration = 0.5
@export var dash_mult = 10

@onready var fsm: FiniteStateMachine = $FiniteStateMachine	
@onready var user_interface = $UserInterface	


func _ready():
	user_interface.set_health_icon(health, health_order)


func _physics_process(_delta):
	move_and_slide()
	control_movement()
	control_look()
	$Label.set_text(str(fsm.current_state))


## Movement controls.
func control_movement():
	var direction = Input.get_vector("controls_left", "controls_right", "controls_up", "controls_down")

	#TODO СЫРАЯ РЕАЛИЗАЦИЯ РЫВКА !!!!!!! УБРАТЬ И ПЕРЕДЕЛАТЬ!!!!
	var mult = 1
	if Input.is_action_just_pressed("controls_dash"):
		mult = 4
		$Character/immortalityAnim.play("dodge")

	if direction.length_squared() > 0:
		velocity = velocity.lerp(direction.normalized() * speed * mult, acceleration * mult)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)


## Look direction controls (follows mouse). Selects from 8 directions and sets frame.
func control_look():
	var mouse = get_local_mouse_position()
	var angle = snappedf(-mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	var frame = wrapi(angle - 6, 0, 8)
	$Character.frame = frame


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