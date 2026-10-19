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
var coyote_frames : int = 3 # this number doesn't matter, check on_enter()
var after_image_toggle : bool = false
var after_image = 5

#var climb_buffer = 0
var air_velocity : float = 120
var has_double_jumped = false

func state_process(delta, direction):
	if after_image_toggle:
		if after_image > 0:
			after_image -=1
		else:
			after_image = 5
			character.after_image()
	if coyote_frames > 0:
		coyote_frames -= 1
	if character.ceilinghit:
		if character.is_on_ceiling():
			if character.local_velocity.y < 0:
				character.local_velocity.y = 0
	if Input.is_action_pressed("up"):
		if character.ladder && character.climb_buffer == 0:
			playback.travel("climbing")
			next_state = climb_state
	if Input.is_action_pressed("down") && character.climb_buffer == 0:
		if character.ladderdown:
			character.position.y += 4
			playback.travel("climbing")
			next_state = climb_state
		elif character.ladder && !character.is_on_floor():
			playback.travel("climbing")
			next_state = climb_state
	if character.is_on_floor():
		land_sound.play()
		character.local_velocity.y = 0
		next_state = ground_state
		if direction.x != DDirection.NONE:
			next_state = running_state
		playback.travel("idle")
	else:
		character.local_velocity.x = air_velocity*sign(direction.x)
		if character.local_velocity.y < character.gravity:
			character.local_velocity.y += character.gravity * delta
	
	shoot_anim_timer("jump") # State.gd
	if character.climb_buffer > 0:
		character.climb_buffer -= 1
	
	if character.hurt:
		character.hurt = false
		owie()

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		if coyote_frames > 0 && character.last_state == sliding_state:
			jump()
		elif character.weapon_current == character.weapon_rushcoil && character.weapon_current.ex && character.weapon_current.ammo > 0 && !has_double_jumped:
			# possibly make it passive but still 
			has_double_jumped = true
			character.weapon_current.ammo -= 1
			character.camera.ammobar.value = character.weapon_current.ammo
			jump()
	if event.is_action_released("jump") && character.local_velocity.y  < 0:
		character.local_velocity.y = 0
	if event.is_action_pressed("fire"):
		shoot_anim("jump_shoot") # State.gd
		fire()
	if event.is_action_released("fire"):
		shoot_anim("jump_shoot") # State.gd
		if character.shader_intensity > 0.25:
			charge_shot()

func on_enter():
	has_double_jumped = false
	after_image = 1
	coyote_frames = 6
	if !Input.is_action_pressed("jump"):
		character.local_velocity.y = 0
	sprite.offset.y = 5
	playback.travel("jump")
	if character.last_state == sliding_state:
		air_velocity = character.slide_velocity
		after_image_toggle = true
		return
	air_velocity = character.speed
	after_image_toggle = false

func on_exit():
	sprite.offset.y = 1
	air_velocity = character.speed
	if next_state == ground_state:
		playback.travel("idle")

func fire():
	character.weapon_current.fire_weapon(Vector2(16,10), 0)
	
func charge_shot():
	if character.shader_intensity <= 0.25:
		return
	elif character.shader_intensity < 0.7:
		character.weapon_current.fire_weapon(Vector2(16, 10), 0)
	else:
		character.weapon_current.fire_charged_weapon(Vector2(16, 10), 0)

func jump():
	character.local_velocity.y = character.jump_velocity
