extends State
@export var climb : State
var stun = 45

func on_enter():
	character.owie = true
	stun = 46
	character.local_velocity.y = 0
	playback.travel("climb_hurt")
	
func on_exit():
	character.owie = false

func state_process(_delta, _direction):
	stun -= 1
	if stun <= 0:
		next_state = climb
