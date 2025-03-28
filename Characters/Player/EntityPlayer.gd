class_name EntityPlayer
extends Entity

@export var body_state_machine: FiniteStateMachine
@export var invulnerability_state_machine: FiniteStateMachine
@export var hands_state_machine: FiniteStateMachine

#@export var invulnerability_animation: AnimationPlayer
#@export var hands_animation: AnimationPlayer
@export var invulnerability_timer: Timer

@export var max_mana: float = 10.0
var mana: float = max_mana
var money: int = 0
var signs: Array[GlobalData.SIGNS] = []
var basic_weapons: Array[WeaponBasic] = []
var special_weapons: Array[WeaponSpecial] = []
var items: Array[Item] = []
@export var basic_weapon: WeaponBasic # testing

signal signs_changed(new_signs: Array[GlobalData.SIGNS])

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if is_active:
		handle_movement(delta)
		handle_look()
		handle_basic_attack()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("controls_sign_shaka"):
		handle_sign(GlobalData.SIGNS.SHAKA)
	elif event.is_action_pressed("controls_sign_goat"):
		handle_sign(GlobalData.SIGNS.GOAT)
	elif event.is_action_pressed("controls_sign_you"):
		handle_sign(GlobalData.SIGNS.YOU)


# :Entity.
func handle_movement(_delta: float) -> void:
	var direction = Input.get_vector("controls_left", "controls_right", "controls_up", "controls_down")
	
	var mult = 1
	if Input.is_physical_key_pressed(KEY_SHIFT):
		mult = 4
	
	if Input.is_action_just_pressed("controls_dash"):
		dodge(direction)
	
	if direction.length_squared() > 0:
		velocity = velocity.lerp(direction.normalized() * movement_speed * mult, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	move_and_slide()


func dodge(direction: Vector2) -> void:
	velocity = velocity.lerp(direction.normalized() * movement_speed * 100, acceleration)


# :Entity.
func update_animation(_delta: float) -> void:
	pass


# :Entity.
func get_interaction() -> void:
	pass


func handle_basic_attack() -> void:
	if Input.is_action_pressed("controls_base_attack"):
		basic_weapon.attack()
	elif Input.is_action_just_released("controls_base_attack"):
		basic_weapon.stop_attack()


func handle_sign(new_sign: GlobalData.SIGNS) -> void:
	signs.append(new_sign)
	signs_changed.emit(signs)
	print("Sign " + str(new_sign))
	if signs.size() == 3:
		print("Got 3 signs: %s %s %s. Clearing..." % signs)
		signs.clear()
	


# :Entity.
func take_damage(amount: float) -> void:
	if is_invulnerable:
		print("Player skiped damage")
		return
		
	print("Player took damage: " + str(amount))
	
	hp -= amount
	
	damage_taken.emit(amount)
	
	if hp <= 0:
		die()
		return
	
	is_invulnerable = true
	invulnerability_timer.start(invulnerability_duration)


# :Entity.
func die() -> void:
	is_active = false
	died.emit()


func handle_look() -> void:
	var mouse := get_local_mouse_position()
	facing_direction = mouse.normalized()
	var angle := snappedf(-mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	var frame := wrapi(int(angle - 6.0), 0, 8)
	sprite.frame = frame

	#FIXME Временный зум
	if Input.is_action_just_released("controls_mouse_wheel_up"):
		$Camera2D.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_released("controls_mouse_wheel_down"):
		$Camera2D.zoom -= Vector2(0.1, 0.1)


func _on_invulnerabity_timer_timeout() -> void:
	is_invulnerable = false
