extends State
@export var climb_hurt : State
@export var ground_state : State
@export var air_state : State
@export var animplayer : AnimationPlayer
@export var tree : AnimationTree

func on_enter():
	playback.travel("climbing")
	character.local_velocity.y = 0
	tree.set("parameters/TimeScale/scale", 0)
	can_move = false
	character.global_position.x = character.ladderpos
	
func on_exit():
	can_move = true

func state_process(_delta, direction):
	character.local_velocity.x = 0
	
	if direction.y != 0:
		playback.travel("climbing")
		character.local_velocity.y = character.speed*sign(direction.y)
	else:
		playback.travel("climbing_pause")
		character.local_velocity.x = 0
		character.local_velocity.y = 0
	if Input.is_action_just_pressed("jump"):
		playback.travel("jump")
		if character.ladderjump:
			character.local_velocity.y = character.jump_velocity
		next_state = air_state
	if Input.is_action_just_pressed("slide"):
		playback.travel("jump")
		next_state = air_state
	if Input.is_action_pressed("down") && character.is_on_floor():
		playback.travel("idle")
		next_state = ground_state
	if !character.ladder:
		playback.travel("jump")
		next_state = air_state

	#shoot_anim_timer("climbing_pause") # State.gd
