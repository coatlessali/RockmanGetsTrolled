extends State

class_name RunStart
#@export var jump_velocity : float = -225.0
#@export var slide_velocity : float = 200
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var ground_state : State
@export var default_pause_frames : int = 6
@export var sprite : Sprite2D
@export var climb_state : State
var pause_frames : int = 30

func on_enter():
	pause_frames = default_pause_frames
	playback.travel("run_start")
	sprite.offset.x = 5

func on_exit():
	sprite.offset.x = 5

func state_process(_delta, direction):
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
	# you air be in the shouldn't!
	if sprite.flip_h == true:
		sprite.offset.x = 4
	else:
		sprite.offset.x = 6
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		pause_frames -= 1
		if direction.x != 0:
			# check if we're pressing the opposite direction and start braking
			#if (direction.x * character.local_velocity.x < 0):
				#next_state = braking_state
			# apply velocity
			#else:
			#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed*2)
			#character.local_velocity.x = character.speed/2*sign(direction.x)
			character.local_velocity.x = 0
			if pause_frames <= 0:
				next_state = running_state
		# if we're not pressing anything, go into idle if we're not doing anything, or go into braking if we are
		elif direction.x == 0:
			#if character.velocity.x == 0:
			next_state = ground_state
			playback.travel("idle")
			#else:
				#next_state = braking_state
				#playback.travel("idle")
	if character.hurt:
		character.hurt = false
		owie()

func state_input(event : InputEvent):
	if event.is_action_pressed("debug_owie"):
		owie() # test hurting for the time being, comment out this line and the one above it to turn it off
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
	if event.is_action_released("fire"):
		if character.shader_intensity > 0.25:
			var fire_funne = 69
			if character.last_faced == DDirection.RIGHT:
				fire_funne = 0
			else:
				fire_funne = deg_to_rad(180)
			charge_shot(fire_funne)
	
func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state
	playback.travel("jump")

func slide():
	character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	next_state = slide_state

func fire(angle):
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(character.last_faced*16, 10)

func charge_shot(angle):
	if character.weapon == "buster":
		if character.shader_intensity <= 0.25:
			return
		var bullet = load("Bullet.tscn").instantiate()
		if character.shader_intensity >= 0.70:
			bullet = load("res://ChargeBullet.tscn").instantiate()
		bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
		get_parent().add_child(bullet)
		bullet.position = character.position + Vector2(character.last_faced*16, 10)
