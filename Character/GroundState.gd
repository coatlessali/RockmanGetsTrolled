extends State

class_name GroundState

#@export var jump_velocity : float = -225.0
#@export var slide_velocity : float = 200
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var runstart_state : State
@export var sprite : Sprite2D
@export var climb_state : State

func state_process(_delta, direction):
	if character.hurt:
		owie()
	
	if Input.is_action_pressed("up"):
		if character.ladder:
			playback.travel("climbing")
			next_state = climb_state
			print("climb")
	if Input.is_action_pressed("down"):
		if character.ladderdown:
			character.position.y += 4
			playback.travel("climbing")
			next_state = climb_state
			print("climb")
		elif character.ladder && !character.is_on_floor():
			playback.travel("climbing")
			next_state = climb_state
			print("climb")
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		# check if we're pressing anything and transition into running
		if direction.x != 0:
			character.local_velocity.x = character.speed*sign(direction.x/2)
			next_state = runstart_state
			playback.travel("run")
		else:
			character.local_velocity.x = 0

	shoot_anim_timer("idle") # State.gd

func state_input(event : InputEvent):
	#if event.is_action_pressed("debug_owie"):
		#owie() # test hurting for the time being, comment out this line and the one above it to turn it off
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("slide"):
		#owie()
		slide()
	if event.is_action_pressed("fire"):
		var fire_funne = 69
		if character.last_faced == DDirection.RIGHT:
			fire_funne = 0
		elif character.last_faced == DDirection.LEFT:
			fire_funne = deg_to_rad(180)
		fire(fire_funne)

		shoot_anim("idle_shoot") # State.gd


func on_enter():
	sprite.offset.y = 1
	slide_hurtbox.disabled = true
	hurtbox.disabled = false

func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state

func slide():
	character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	next_state = slide_state

func fire(angle):
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(character.last_faced*16, 11)
