extends ProgressBar
var timer = false

func _physics_process(_delta: float) -> void:
	if timer:
		get_theme_stylebox("fill").bg_color = Color(0.09, 0.09, 0.09)
	else:
		get_theme_stylebox("fill").bg_color = Color(0.18, 0.39, 0.54)
	timer = !timer
