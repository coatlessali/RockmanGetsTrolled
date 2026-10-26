extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.0


func _physics_process(_delta: float) -> void:
	if modulate.a < 1.0:
		modulate.a += 0.0075
	else:
		queue_free()


func _on_audio_stream_player_finished() -> void:
	queue_free()
