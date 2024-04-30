extends CharacterBody2D

@export var nav_agent: NavigationAgent2D
@export var speed = 35
var player_chase = false
var player = null
var animState = ""
var target_node = null
func _ready():
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
		
	if player_chase:
		var axis = to_local(nav_agent.get_next_path_position()).normalized()
		position += axis*speed*delta
		print(position)
		#print(str(player.position.x - position.x) + " " + str(player.position.y - position.y))
		#if (player.position.x - position.x) < -10:
			#if (player.position.y - position.y) < -10:
				#animState = "walk_left_up"
			#elif (player.position.y - position.y) > 10:
				#animState = "walk_left_down"
			#else:
				#animState = "walk_left"
		#elif (player.position.x - position.x) > 10:
			#if (player.position.y - position.y) < -10:
				#animState = "walk_right_up"
			#elif (player.position.y - position.y) > 10:
				#animState = "walk_right_down"
			#else:
				#animState = "walk_right"
		#else:
			#if (player.position.y - position.y) < 0:
				#animState = "walk_up"
			#else: animState = "walk_down"
	else: 
		animState = "idle"
	#print(str(animState))
	#$Character/PlayerAnimation.play(animState)
	move_and_slide()
		

func _on_recalculate_timer_timeout():
	recalc_path()
	

func recalc_path():
	if target_node:
		nav_agent.target_position = target_node.global_position


func _on_aggro_range_area_entered(area):
	print(area)
	target_node = area.owner
	player_chase = true



func _on_aggro_range_area_exited(area):
	print(area)
	if area.owner == target_node:
		target_node = null
	player_chase = false

