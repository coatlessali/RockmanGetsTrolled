extends State

@export var explotano : AnimatedSprite2D
@export var audio : AudioStreamPlayer
@export var idle : State
var pause : int = 30

func state_process(_delta, _direction):
	pause -= 1
	if pause == 0:
		character.sprite.hide()
		explotano.visible = true
		audio.play()
		explotano.play()

func on_enter():
	if randi_range(1, 100) == 1:
		var ctac = load("res://ctac.tscn").instantiate()
		get_parent().get_parent().camera.add_child(ctac)
	character.local_velocity = Vector2(0, 0)
	can_move = false
	pause = 30
	character.music.stop()

func _on_audio_stream_player_finished() -> void:
	character.owie = false
	character.dead = false
	can_move = true
	character.sprite.show()
	next_state = idle
	character.position = character.home_pos
	character.hp = 28
	character.camera.healthbar.value = 28
	character.music.play()
	character.camera.global_position = character.cam_pos
	character.respawn = true


func _on_explotano_sprite_animation_finished() -> void:
	explotano.visible = false
