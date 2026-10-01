extends State

class_name GroundState

# CHECK RUNNING STATE JUMP VELOCITY
@export var jump_velocity : float = -225.0
@export var slide_velocity : float = 200
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var runstart_state : State

func state_process(_delta, direction):
	# you shouldn't be in the air!
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		#print_debug(direction.x)
		# check if we're pressing anything and transition into running
		if direction.x != 0:
			#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed)
			character.local_velocity.x = character.speed*sign(direction.x/2)
			next_state = runstart_state
			playback.travel("run")
		else:
			character.local_velocity.x = 0

	shoot_anim_timer("idle") # State.gd

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("slide"):
		slide()
	if event.is_action_pressed("fire"):
		var fire_funne = 69
		if character.last_faced == DDirection.RIGHT:
			fire_funne = 0
		elif character.last_faced == DDirection.LEFT:
			fire_funne = deg_to_rad(180)
		fire(fire_funne)

		shoot_anim("idle_shoot") # State.gd


func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state
	#playback.travel("jump")
	#print_debug("travelled to jump")


func slide():
	character.local_velocity.x = slide_velocity*sign(character.last_faced)
	next_state = slide_state
	#playback.travel("slide")

# TODO: copy to other states once finalized
func fire(angle):
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(character.last_faced*16, 10)
