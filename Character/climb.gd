extends State
@export var climb_hurt : State
@export var ground_state : State
@export var air_state : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_enter():
	#playback.travel("climbing")
	character.local_velocity.y = 0
	can_move = false
	
func on_exit():
	can_move = true

func state_process(_delta, direction):
	character.local_velocity.x = 0
	#if Input.is_action_just_pressed("debug_owie"):
		#next_state = climb_hurt
	if Input.is_action_just_pressed("jump"):
		playback.travel("jump")
		next_state = air_state
	else:
		#print_debug(direction.x)
		# check if we're pressing anything and transition into running
		if direction.y != 0:
			#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed)
			character.local_velocity.y = character.speed*sign(direction.y)
			#next_state = runstart_state
			playback.travel("run")
		else:
			character.local_velocity.x = 0
			character.local_velocity.y = 0

	shoot_anim_timer("idle") # State.gd
