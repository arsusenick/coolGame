extends CharacterBody2D

signal shoot

@export var speed = 50
var testDirect: Dictionary = {0:2, 1:1, 2:0, 3:7, 4:6, 5:5, 6:4, 7:3}
@export var can_shoot: bool

var screen_size: Vector2
var animState = "idle"
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

	position = Vector2(200,150)

	can_shoot = true
	speed = 50

func get_input(anima):
	var input_dir = Input.get_vector("left","right","up","down")
	#print(input_dir)
	velocity = input_dir.normalized() * speed
	if(input_dir.x != 0 or input_dir.y != 0):
		$Character/PlayerAnimation.play(anima)
	else:
		$Character/PlayerAnimation.stop()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		$AnimatedSprite2D.play()
		$ShootTimer.start()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):
	
	move_and_slide()

	position = position.clamp(Vector2.ZERO, screen_size)
	
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

func play_anim(direction: Vector2):
	if (direction.x > 0):
		if (direction.y > 0):
			animState = "walk_right_down"
		elif (direction.y < 0):
			animState = "walk_right_up"
		else:
			animState = "walk_right"
	elif (direction.x < 0):
		if (direction.y > 0):
			animState = "walk_left_down"
		elif (direction.y < 0):
			animState = "walk_left_up"
		else:
			animState = "walk_left"
	else:
		if (direction.y > 0):
			animState = "walk_down"
		elif (direction.y < 0):
			animState = "walk_up"
	$Character/PlayerAnimation.play(animState)


func _on_shoot_timer_timeout():
	$AnimatedSprite2D.stop()
	can_shoot = true # Replace with function body.
