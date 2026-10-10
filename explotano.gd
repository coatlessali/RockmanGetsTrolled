extends AnimatedSprite2D
@onready var sound : AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
func _on_animation_finished() -> void:
	visible = false
func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
