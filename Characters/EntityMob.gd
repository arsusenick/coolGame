class_name EntityMob
extends Entity

@export var navigation_agent: NavigationAgent2D
@export var aggro_area: Area2D

@export var drop: int = 0
@export var is_aggressive: bool = true

@export_group("Attack")
@export var attack_speed: float = 1.0 # in attacks per second
@export var attack_damage: float = 1.0
@export_group("")

var target: Entity = null
var player_chase = false
var player = null
var alive = true
var animState = "idle"
var target_node: Node2D = null

signal aggroed(target: Entity)


func _ready() -> void:
	$Label.set_text(str(hp))
	navigation_agent.path_desired_distance = 4
	navigation_agent.target_desired_distance = 4


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	if player_chase and alive:
		var axis = to_local(navigation_agent.get_next_path_position()).normalized()
		position += axis * movement_speed * delta
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
	
	$Character/PlayerAnimation.play(animState)
	move_and_slide()


func update_ai() -> void:
	pass

func attack() -> void:
	pass


# :Entity.
func handle_movement(delta: float) -> void:
	pass


# :Entity.
func update_animation(delta: float) -> void:
	pass


# :Entity.
func get_interaction() -> void:
	pass


# :Entity.
func take_damage(amount: float) -> void:
	print(str(hp) + " " + str(amount) + " hit!")
	hp -= amount
	$Label.set_text(str(hp))
	
	damage_taken.emit(amount)
	
	if hp <= 0 and alive:
		die()


func _on_invulnerability_timer_timeout() -> void:
	is_invulnerable = false


# :Entity.
func die() -> void:
	alive = false
	target_node = null
	navigation_agent.target_position = position
	print("death")
	animState = "death"
	$Character/PlayerAnimation.play(animState)
	$Aggr/AggroRange.set_collision_mask_value(2, false)
	set_collision_layer_value(3, false)


func _on_recalculate_timer_timeout():
	recalc_path()


func recalc_path():
	if target_node:
		navigation_agent.target_position = target_node.global_position


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
