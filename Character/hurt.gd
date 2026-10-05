extends State

var hurt_timer = 45
@export var ground_state : State
@export var air_state : State
@export var slide_state : State
# Called when the node enters the scene tree for the first time.

func on_enter():
	character.local_velocity.y = 0
	hurt_timer = 45
	character.owie = true

func on_exit():
	character.owie = false

func state_process(_delta, _direction):
	if hurt_timer > 0:
		hurt_timer -= 1
		if not character.is_on_floor():
			if character.local_velocity.y < character.gravity:
				character.local_velocity.y += character.gravity * _delta
		if !slidecast.is_colliding():
			character.local_velocity.x = -character.last_faced*character.speed/4
		else:
			character.local_velocity.x = 0
	else:
		if character.is_on_floor():
			if slidecast.is_colliding():
				playback.travel("slide")
				next_state = slide_state
			else:
				playback.travel("idle")
				next_state = ground_state
		else:
			playback.travel("jump")
			next_state = air_state
	if character.dead:
		next_state = dead_state
