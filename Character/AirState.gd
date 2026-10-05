extends State

class_name AirState

#@export var double_jump_velocity : float = -100
@export var ground_state : State
@export var running_state : State
@export var running_start_state : State
@export var sliding_state : State
@export var sprite : Sprite2D
@export var land_sound : AudioStreamPlayer
@export var climb_state : State

#var climb_buffer = 0
var air_velocity : float = 120
var has_double_jumped = false

func state_process(delta, direction):
	if character.ceilinghit:
		if character.is_on_ceiling():
			if character.local_velocity.y < 0:
				character.local_velocity.y = 0
	if Input.is_action_pressed("up"):
		if character.ladder && character.climb_buffer == 0:
			playback.travel("climbing")
			next_state = climb_state
			print("climb")
	if Input.is_action_pressed("down") && character.climb_buffer == 0:
		if character.ladderdown:
			character.position.y += 4
			playback.travel("climbing")
			next_state = climb_state
			print("climb")
		elif character.ladder && !character.is_on_floor():
			playback.travel("climbing")
			next_state = climb_state
			print("climb")
	if(character.is_on_floor()):
		land_sound.play()
		character.local_velocity.y = 0
		#if Input.is_action_pressed("slide"):
			#next_state = sliding_state
		if direction.x != DDirection.NONE:
			next_state = running_state
		else:
			next_state = ground_state
		playback.travel("idle")
	else:
		if character.local_velocity.y < character.gravity:
			character.local_velocity.y += character.gravity * delta
		else:
			pass
		#character.local_velocity.x = character.speed*sign(direction.x)
		character.local_velocity.x = air_velocity*sign(direction.x)
		
	shoot_anim_timer("jump") # State.gd
	if character.climb_buffer > 0:
		character.climb_buffer -= 1
	
	if character.hurt:
		character.hurt = false
		owie()

func state_input(event : InputEvent):
	if event.is_action_pressed("debug_owie"):
		owie() # test hurting for the time being, comment out this line and the one above it to turn it off
	#if character.hurt:
		#character.hurt = false
		#owie()
	if event.is_action_released("jump") && character.local_velocity.y  < 0:
		character.local_velocity.y = 0
	if event.is_action_pressed("fire"):
		var fire_funne = 69
		if character.last_faced == DDirection.RIGHT:
			fire_funne = 0
		elif character.last_faced == DDirection.LEFT:
			fire_funne = deg_to_rad(180) # PI or 3.1415926536
		fire(fire_funne)
		
		shoot_anim("jump_shoot") # State.gd

func on_enter():
	#climb_buffer = 6
	if !Input.is_action_pressed("jump"):
		character.local_velocity.y = 0
	sprite.offset.y = 5
	# Determines whether to jump with sliding speed
	playback.travel("jump")
	if(character.last_state == sliding_state):
		air_velocity = character.slide_velocity
	else:
		air_velocity = character.speed

func on_exit():
	sprite.offset.y = 1
	air_velocity = character.speed
	if(next_state == ground_state):
		#has_double_jumped = false
		playback.travel("idle")

func fire(angle):
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(character.last_faced*16, 3)
