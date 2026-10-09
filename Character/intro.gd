extends State

@export var ground_state : State
@export var land : AudioStreamPlayer

func on_enter():
	pass
	
	#character.sprite.visible = false

func on_exit():
	actual_hurtbox.monitoring = true

func state_process(_delta, _direction):
	if character.camera.readyplayed:
		character.sprite.visible = true
		playback.travel("intro")
		actual_hurtbox.monitoring = false
		slide_actual_hurtbox.monitoring = false
		if !character.is_on_floor():
			character.local_velocity.y = 400
		else:
			playback.travel("idle")
			land.play()
			next_state = ground_state
	else:
		character.sprite.visible = false
