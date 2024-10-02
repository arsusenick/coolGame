extends CharacterBody2D

signal shoot
signal pickUp

@export var can_shoot: bool = false

@onready var playerStats = $Stats
@onready var timer = $ShootTimer
@onready var user_interface = $UserInterface


var testDirect: Dictionary = {0:2, 1:1, 2:0, 3:7, 4:6, 5:5, 6:4, 7:3}
var animState = "idle"
var bullet_damage = 0
var bullet_speed = 0
var weaponName = null


# Called when the node enters the scene tree for the first time.
func _ready():
	user_interface.set_health_icon(playerStats.player_health, playerStats.order)

func get_weapon_stats():
	bullet_damage = playerStats.player_weapon.damage
	timer.wait_time = 60 / playerStats.player_weapon.attackSpeed
	bullet_speed = playerStats.player_weapon.projectile_speed
	can_shoot = true
	
func get_input(anima):
	var input_dir = Input.get_vector("left","right","up","down")
	#print(input_dir)
	velocity = input_dir.normalized() * playerStats.player_speed
	if(input_dir.x != 0 or input_dir.y != 0):
		$Character/moveAnim.play(anima)
	else:
		$Character/moveAnim.stop()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		user_interface.set_health_icon(playerStats.player_health, playerStats.order)
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir, bullet_damage, bullet_speed, playerStats.player_weapon.projectile)
		can_shoot = false

		$ShootTimer.start()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):
	move_and_slide()
	if Input.is_action_just_pressed("e") and weaponName != null:
		playerStats.player_weapon = weaponName
		get_weapon_stats()
		pickUp.emit(weaponName)
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	match (angle):
		0:
			animState = "walk_right"
		1:
			animState = "walk_right_down"
		2:
			animState = "walk_down"
		3:
			animState = "walk_left_down"
		4:
			animState = "walk_left"
		5:
			animState = "walk_left_up"
		6:
			animState = "walk_up"
		7:
			animState = "walk_right_up"
	get_input(animState)
	$Character.frame = testDirect[angle]
	#print(angle)

func get_damage(dmg: int):
	print(str(dmg)+" lol")
	playerStats.change_health(dmg)
	user_interface.set_health_icon(playerStats.player_health, playerStats.order)
	$immortalityTimer.start()
	$Character/immortalityAnim.play("immortality")
	set_collision_layer_value(2, false)

func _on_shoot_timer_timeout():
	can_shoot = true # Replace with function body.

func _on_area_2d_area_entered(area):
	if area.get_scene_file_path() == "basic_weapon" && area.get_weapon_type() == "basic_weapon":
		weaponName = area
		
func _on_area_2d_area_exited(area):
	if area.get_scene_file_path() == "basic_weapon" && area.get_weapon_type() == "basic_weapon":
		weaponName = null


func _on_immortality_timer_timeout():
	$Character/immortalityAnim.stop()
	set_collision_layer_value(2, true)
