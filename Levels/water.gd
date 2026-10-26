extends Parallax2D

@export var home : float = 98
@export var splashzone : Area2D
var time : float = 0.0
var speed : float = 1.0
var amplitude : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	scroll_offset.y = home + sin(time * speed) * amplitude
	splashzone.position.y = scroll_offset.y
