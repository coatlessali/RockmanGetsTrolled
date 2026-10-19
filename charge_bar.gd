extends ProgressBar
var timer = true

func _physics_process(_delta: float) -> void:
	timer = !timer
	if timer:
		get_theme_stylebox("fill").bg_color = Color(0.09, 0.09, 0.09)
		return
	get_theme_stylebox("fill").bg_color = Color(1.0, 0.3, 0.5)
	
