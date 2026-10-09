extends Camera2D
@export var character : CharacterBody2D
@onready var readytext : AnimatedSprite2D = $Ready
var air_buffer : bool = true
var buffer : bool = false
var readyplayed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	readytext.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Checks to see if the room allows following the y axis.
	if character.cam_follow_y:
		position.y = move_toward(position.y,character.global_position.y,8)
		air_buffer = true
	if character.is_on_floor():
		air_buffer = false
	if character.cam_follow_x:
		#print(character.global_position.x)
		#print(position.x)
		position.x = move_toward(position.x,character.global_position.x,4)
		#position.x = position.x.lerp(position.x,character.position.x,4 * delta)
		#position.x = character.position.xN


func _on_ready_animation_finished() -> void:
	readyplayed = true
