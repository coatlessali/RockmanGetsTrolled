extends Camera2D
@export var character : CharacterBody2D
@onready var readytext : AnimatedSprite2D = $Ready
@onready var healthbar : TextureProgressBar = $HealthFrame/HealthBar
@onready var ammobar : TextureProgressBar = $AmmoFrame/AmmoBar
@onready var ammoframe : Sprite2D = $AmmoFrame
@onready var textpopup : RichTextLabel = $RichTextLabel
@onready var grazearea : Area2D = character.get_node("GrazeArea")
@onready var grazebar : ProgressBar = $AmmoFrame/GrazeBar
@onready var needle : Node2D = $OtherBars/Needle
@onready var chargebar : ProgressBar = $HealthFrame/ChargeBar
var air_buffer : bool = true
var buffer : bool = false
var readyplayed : bool = false
var text_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ammoframe.hide()
	readytext.play()
	textpopup.hide()

func _physics_process(delta: float) -> void:
	if text_timer > 0:
		text_timer -= 1
	else:
		textpopup.hide()

func _on_ready_animation_finished() -> void:
	readyplayed = true

func text_popup(content : String) -> void:
	textpopup.text = content
	textpopup.show()
	text_timer = 360
