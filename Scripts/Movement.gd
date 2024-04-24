extends CharacterBody2D

var speed = 50  # speed in pixels/sec

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	velocity = direction * speed * delta * 100
	
	var animState = "idle"
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

	move_and_slide()
	print(direction)
