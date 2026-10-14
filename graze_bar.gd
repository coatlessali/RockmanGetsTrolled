extends ProgressBar
var timer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if timer:
		get_theme_stylebox("fill").bg_color = Color(0.09, 0.09, 0.09)
	else:
		get_theme_stylebox("fill").bg_color = Color(0.18, 0.39, 0.54)
	timer = !timer
