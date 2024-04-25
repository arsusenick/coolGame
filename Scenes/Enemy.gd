extends CharacterBody2D

@export var speed = 30
var player_chase = false
var player = null
var animState = ""

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)*delta/speed
		#print(str(player.position.x - position.x) + " " + str(player.position.y - position.y))
		if (player.position.x - position.x) < -10:
			if (player.position.y - position.y) < -10:
				animState = "walk_left_up"
			elif (player.position.y - position.y) > 10:
				animState = "walk_left_down"
			else:
				animState = "walk_left"
		elif (player.position.x - position.x) > 10:
			if (player.position.y - position.y) < -10:
				animState = "walk_right_up"
			elif (player.position.y - position.y) > 10:
				animState = "walk_right_down"
			else:
				animState = "walk_right"
		else:
			if (player.position.y - position.y) < 0:
				animState = "walk_up"
			else: animState = "walk_down"
	else: 
		animState = "idle"
	#print(str(animState))
	$Character/PlayerAnimation.play(animState)
	move_and_slide()

func _on_detector_body_entered(body):
	#print(body)
	if body.name == "Player":
		#print("ok")
		player = body
		player_chase = true
	#else: print("nePlayer")

func _on_detector_body_exited(body):
	if body.name == "Player":
		player = null
		player_chase = false
