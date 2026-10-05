extends State

@export var explotano : AnimatedSprite2D
@export var audio : AudioStreamPlayer
@export var idle : State

func on_enter():
	character.local_velocity = Vector2(0, 0)
	can_move = false
	character.sprite.hide()
	explotano.visible = true
	audio.play()
	explotano.play()
	character.music.stop()

func _on_audio_stream_player_finished() -> void:
	character.owie = false
	character.dead = false
	can_move = true
	character.sprite.show()
	next_state = idle
	character.position = Vector2(0, 0)
	character.hp = 28
	character.music.play()
	character.camera.position = Vector2(0, 88)


func _on_explotano_sprite_animation_finished() -> void:
	explotano.visible = false
