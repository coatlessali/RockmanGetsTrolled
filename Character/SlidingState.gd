extends State

# TODO: implement this
class_name SlideState

# CHECK RUNNING STATE JUMP VELOCITY
#@export var jump_velocity : float = -200.0
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var ground_state : State
@export var runstart_state : State
@export var timer : int = 69
@export var slide_dir : int = 1
@export var sprite : Sprite2D
@export var climb_state : State
var slide_buffer : int = 2
var dust_timer = 18
var after_image = 5

func state_process(_delta, direction):
	if dust_timer % 6 == 0:
		dust()
	dust_timer -= 1
	if after_image > 0:
		after_image -=1
	else: # if slip_timer <= 0:
		after_image = 5
		character.after_image()
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
	if slide_buffer > 0:
		slide_buffer -= 1
	if(character.is_on_wall() && slide_buffer == 0):
		if character.is_on_floor():
			next_state = ground_state
		else:
			next_state = air_state
			if character.is_on_ceiling_only():
				# janky workaround for getting stuck in the ceiling after sliding off an edge while under a ceiling
				character.position.y += 14
	
	if(!character.is_on_floor()):
		next_state = air_state
		if slidecast.is_colliding():
			# janky workaround for getting stuck in the ceiling after sliding off an edge while under a ceiling
			character.position.y += 14
	else:
		timer -= 1
		if sign(direction.x)*slide_dir == -1:
			if slidecast.is_colliding():
				slide()
			else:
				next_state = ground_state
				playback.travel("idle")
		else:
			character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
		if timer <= 0:
			if slidecast.is_colliding():
				return
			elif sign(direction.x)*slide_dir == 1:
				next_state = running_state
			else:
				next_state = ground_state
				playback.travel("idle")
		
	shoot_anim_timer("slide")
	if character.hurt:
		character.hurt = false
		owie()

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		if slidecast.is_colliding():
			return
		else:
			jump()
	if event.is_action_pressed("fire"):
		fire()
		
		shoot_anim("slide_shoot")
	if event.is_action_released("fire"):
		if character.shader_intensity > 0.25:
			var fire_funne = 69
			if character.last_faced == DDirection.RIGHT:
				fire_funne = 0
			else:
				fire_funne = deg_to_rad(180)
			charge_shot(fire_funne)

		shoot_anim("slide_shoot") # State.gd
	
func on_enter():
	character.slidesound.play()
	after_image = 1
	character.sliding = true
	dust_timer = 18
	slide_buffer = 2
	sprite.offset.y = 2
	timer = 25
	slide_dir = character.last_faced
	slide_hurtbox.disabled = false
	slide_actual_hurtbox.monitoring = true
	hurtbox.disabled = true
	actual_hurtbox.monitoring = false
	playback.travel("slide")

func on_exit():
	character.change_palette(character.palettes[character.weapon_num])
	character.sliding = false
	if !slidecast.is_colliding():
		sprite.offset.y = 1
		slide_hurtbox.disabled = true
		hurtbox.disabled = false
		actual_hurtbox.monitoring = true
		slide_actual_hurtbox.monitoring = false
	pass

func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state
	playback.travel("jump")

func slide(): # Do we wanna remove this???
	character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	next_state = slide_state

func fire():
	character.weapon_current.fire_weapon(Vector2(10, 14), 0)

func dust():
	var particle = load("res://Character/slide_dust.tscn").instantiate()
	particle.position = Vector2(character.position.x, character.position.y + 8)
	particle.flip_h = !sprite.flip_h
	get_parent().add_child(particle)

func charge_shot(_angle):
	if character.shader_intensity <= 0.25:
		return
	elif character.shader_intensity < 0.7:
		character.weapon_current.fire_weapon(Vector2(10, 14), 0)
	else:
		character.weapon_current.fire_charged_weapon(Vector2(10, 14), 0)
