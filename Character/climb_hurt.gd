extends State
@export var climb : State
var stun : int = 45

func on_enter():
	character.local_velocity.y = 0
	can_move = false
	playback.travel("climb_hurt")
	
func on_exit():
	can_move = true

func state_process(_delta, _direction):
	if stun > 0:
		stun -= 1
	else:
		next_state = climb
