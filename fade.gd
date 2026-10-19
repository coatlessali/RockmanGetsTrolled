extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	modulate.a -= 0.025
	if modulate.a <= 0:
		queue_free()
