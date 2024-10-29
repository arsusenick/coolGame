extends SubViewport

@onready var camera = $Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	camera.position = owner.find_child("Player").position
