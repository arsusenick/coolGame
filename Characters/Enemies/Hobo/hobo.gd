extends EntityMob

var attack_cooldown:float = 1.0
var attack_cooldown_timer: float = 0.0

func _physics_process(delta: float) -> void:
	super(delta)
	if player_chase and alive and attack_cooldown_timer <= 0:
		$Weapon.shoot(target_node.position - position)
		attack_cooldown_timer = attack_cooldown
	attack_cooldown_timer -= delta
