extends "res://Characters/Enemies/Enemy.gd"

@export var max_health: int = 100
@export var attack_range: float = 200.0
@export var move_speed: float = 100.0
@export var attack_cooldown: float = 2.0
@export var phase_threshold: float = 0.5  # Процент здоровья для смены фазы

var current_health: int = max_health
var anim_state: String = "idle"
func _ready():
    nav_agent = $Navigation/NavigationAgent2D
    nav_agent.path_desired_distance = 4
    nav_agent.target_desired_distance = 4

func _physics_process(delta):
    if not alive or not player:
        return

    if player_chase:
        if nav_agent.is_navigation_finished():
            return

        var axis = to_local(nav_agent.get_next_path_position()).normalized()
        position += axis * move_speed * delta

        update_animation(axis)

    if current_health <= max_health * phase_threshold:
        enter_second_phase()

    if current_health <= 0:
        die()

    move_and_slide()

func update_animation(axis):
    if axis.x < -0.2:
        if axis.y > 0.25:
            anim_state = "walk_left_down"
        elif axis.y < -0.25:
            anim_state = "walk_left_up"
        else:
            anim_state = "walk_left"
    elif axis.x > 0.2:
        if axis.y > 0.25:
            anim_state = "walk_right_down"
        elif axis.y < -0.25:
            anim_state = "walk_right_up"
        else:
            anim_state = "walk_right"
    else:
        if axis.y < 0:
            anim_state = "walk_up"
        else:
            anim_state = "walk_down"

    $Character/PlayerAnimation.play(anim_state)

func get_damage(damage: int):
    current_health -= damage
    if current_health <= 0 and alive:
        die()

func die():
    alive = false
    player_chase = false
    anim_state = "death"
    $Character/PlayerAnimation.play(anim_state)
    set_collision_layer_value(3, false)
    set_collision_mask_value(2, false)
    queue_free()

func recalc_path():
    if player:
        nav_agent.target_position = player.global_position

func enter_second_phase():
    move_speed *= 1.5
    attack_cooldown *= 0.75
    phase_threshold = 0  # Чтобы фаза не менялась повторно

func _on_aggro_range_area_entered(area):
    if area.owner == player || area.owner.name == "Player":
        player = area.owner
        player_chase = true
        recalc_path()

func _on_aggro_range_area_exited(area):
    if area.owner == player:
        player_chase = false
        anim_state = "idle"
        $Character/PlayerAnimation.play(anim_state)

func leap_attack():
    anim_state = "leap"
    $Character/PlayerAnimation.play(anim_state)

    var leap_direction = (player.global_position - global_position).normalized()
    position += leap_direction * move_speed * 2
    if position.distance_to(player.global_position) <= attack_range / 2:
        player.get_damage(30)

func tail_whip_attack():
    anim_state = "tail_whip"
    $Character/PlayerAnimation.play(anim_state)

    var tail_range = 150.0
    if position.distance_to(player.global_position) <= tail_range:
        player.get_damage(25)
