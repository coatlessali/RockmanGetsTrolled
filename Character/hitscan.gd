extends Area2D
var speed = 300.0
var expire = 120
var fade_speed = 0.05
var damage = 6
var limit = true
@export var fire = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	if !fire:
		fire = true
		monitorable = true
		monitoring = true
	else:
		monitoring = false
		monitorable = false
