extends State

class_name SwingState

@export var idle_state : State
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var runstart_state : State
@export var sprite : Sprite2D
@export var climb_state : State
const swing_timer_default : int = 60
var swing_timer : int = 60

func state_process(_delta, _direction):
	swing_timer -= 1
	if(!character.is_on_floor()):
		next_state = air_state
	if character.hurt:
		character.hurt = false
		owie()
	if swing_timer <= 0:
		next_state = idle_state

func state_input(_event : InputEvent):
	pass

func on_enter():
	character.local_velocity.x = 0
	Global.camera_shake = 60
	swing_timer = swing_timer_default
	sprite.offset.y = 1
	slide_hurtbox.disabled = true
	hurtbox.disabled = false

func on_exit():
	if character.is_on_floor():
		playback.travel("idle")
	else:
		playback.travel("jump")

func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state

func slide():
	character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	next_state = slide_state
