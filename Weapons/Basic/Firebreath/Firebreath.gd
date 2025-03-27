extends WeaponBasic

@export var attack_timer: Timer
@export var damage_per_tick: float = 1.0
@export var attack_duration: float = 0.5
@export var cooldown: float = 0.1

var is_active: bool = false
var can_attack: bool = true

var projectile_animation: AnimationPlayer

func _ready() -> void:
	attack_timer.one_shot = true
	projectile_animation = projectile.animation_player
	projectile.visible = false

func _physics_process(_delta: float) -> void:
	if !is_active:
		return
	
	# Обновляем позицию и поворот огня относительно игрока
	projectile.position = player.facing_direction * 24  # Увеличил отступ
	projectile.rotation = player.facing_direction.angle() + PI/2


func attack() -> void:
	if !can_attack:
		return
		
	if !is_active:
		# Начинаем атаку
		projectile.visible = true
		is_active = true
		if projectile_animation.has_animation("start"):
			projectile_animation.play("start")
	
	if !projectile_animation.is_playing():
		if projectile_animation.has_animation("loop"):
			projectile_animation.play("loop")
	# Сбрасываем таймер, пока кнопка зажата
	attack_timer.stop()


func stop_attack() -> void:
	if !is_active:
		return
		
	is_active = false
	# projectile.visible = false
	can_attack = false
	attack_timer.start(cooldown)
	if projectile_animation.has_animation("end"):
		projectile_animation.play("end")


func _on_attack_timer_timeout() -> void:
	can_attack = true
