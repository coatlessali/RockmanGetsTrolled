extends State

class_name RunningState

@export var air_state : State
@export var ground_state : State
@export var slide_state : State
@export var climb_state : State

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
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		if direction.x != 0:
			character.local_velocity.x = character.speed*sign(direction.x)
		
		elif direction.x == 0:
			next_state = ground_state
			playback.travel("idle")
	shoot_anim_timer("run")
	if character.hurt:
		character.hurt = false
		owie()

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("slide"):
		slide()
	if event.is_action_pressed("fire"):
		fire()
		
		shoot_anim("run_shoot")
	if event.is_action_released("fire"):
		if character.shader_intensity > 0.25:
			var fire_funne = 69
			if character.last_faced == DDirection.RIGHT:
				fire_funne = 0
			else:
				fire_funne = deg_to_rad(180)
			charge_shot(fire_funne)

		shoot_anim("run_shoot")

func on_enter():
	playback.travel("run")

func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state

func slide():
	character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	next_state = slide_state

func fire():
	character.weapon_current.fire_weapon(Vector2(16, 10), 0)

func charge_shot(_angle):
	if character.shader_intensity <= 0.25:
		return
	elif character.shader_intensity < 0.7:
		character.weapon_current.fire_weapon(Vector2(16, 10), 0)
	else:
		character.weapon_current.fire_charged_weapon(Vector2(16, 10), 0)
