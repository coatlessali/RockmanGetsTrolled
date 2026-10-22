extends ProgressBar
var timer = false

func _physics_process(_delta: float) -> void:
	if timer:
		get_theme_stylebox("fill").bg_color = Color(0.09, 0.09, 0.09)
	else:
		get_theme_stylebox("fill").bg_color = Color(0.38, 0.49, 0.84)
	timer = !timer
