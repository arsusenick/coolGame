extends CharacterBody2D


@export var nav_agent: NavigationAgent2D
@export var speed = 35
@export var health = 30


var player_chase = false
var player = null
var alive = true
var animState = "idle"
var target_node: Node2D = null
func _ready():
	$Label.set_text(str(health))
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	
	if player_chase and alive:
		#print(target_node)
		var axis = to_local(nav_agent.get_next_path_position()).normalized()
		position += axis*speed*delta
		#print(axis)
		if axis.x < -0.2:
			if axis.y > 0.25:
				animState = "walk_left_down"
			elif axis.y < -0.25:
				animState = "walk_left_up"
			else:
				animState = "walk_left"
		elif axis.x > 0.2:
			if axis.y > 0.25:
				animState = "walk_right_down"
			elif axis.y < -0.25:
				animState = "walk_right_up"
			else:
				animState = "walk_right"
		else:
			if (axis.y < 0):
				animState = "walk_up"
			else:
				animState = "walk_down"
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
	
	#print(str(animState))
	$Character/PlayerAnimation.play(animState)
	move_and_slide()
		
func get_damage(damage: int):
	print(str(health) + " " + str(damage) + " hit!")
	health = health - damage
	$Label.set_text(str(health))
	if health <= 0 and alive:
		death()

func death():
	alive = false
	target_node = null
	nav_agent.target_position = position
	print("death")
	animState = "death"
	$Character/PlayerAnimation.play(animState)
	$Aggr/AggroRange.set_collision_mask_value(2, false)
	set_collision_layer_value(3, false)
	
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
	print("exit")
	if area.owner == target_node:
		target_node = null
	player_chase = false
	if alive:
		animState = "idle"
		$Character/PlayerAnimation.play(animState)

func _on_hit_box_body_entered(body):
	if body.name == "Player":
		print("Touched player!")
		body.take_damage(1)
