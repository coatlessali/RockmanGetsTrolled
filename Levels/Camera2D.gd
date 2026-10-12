extends Camera2D
@export var character : CharacterBody2D
@onready var readytext : AnimatedSprite2D = $Ready
@onready var healthbar : TextureProgressBar = $HealthFrame/HealthBar
@onready var ammobar : TextureProgressBar = $AmmoFrame/AmmoBar
@onready var ammoframe : Sprite2D = $AmmoFrame
var air_buffer : bool = true
var buffer : bool = false
var readyplayed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ammoframe.hide()
	readytext.play()

func _on_ready_animation_finished() -> void:
	readyplayed = true
