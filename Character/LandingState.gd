extends State

class_name LandingState

@export var ground_state : State
@export var braking_state : State
@export var running_state : State

func _physics_process(_delta):
	if character.local_velocity.x != 0:
		if character.input_direction.x != DDirection.NONE:
			next_state = running_state
		else:
			next_state = braking_state
	else:
		next_state = ground_state
