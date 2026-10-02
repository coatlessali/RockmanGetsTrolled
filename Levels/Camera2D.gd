extends Camera2D
@export var character : CharacterBody2D
var follow_y : bool = false
var air_buffer : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Checks to see if the room allows following the y axis.
	if follow_y || air_buffer:
		position.y = character.position.y
		air_buffer = true
	if character.is_on_floor():
		air_buffer = false
	position.x = character.position.x
