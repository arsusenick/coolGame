extends StaticBody2D
class_name Door

@export var isVertical = false

@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready():
	animator.play("RESET")
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("doors_appear"):
		animator.play("appear")
	if Input.is_action_just_pressed("doors_disappear"):
		animator.play("disappear")
