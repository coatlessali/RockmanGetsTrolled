extends State
@export var ground_state : State
@export var air_state : State
@export var animplayer : AnimationPlayer
@export var tree : AnimationTree
var xdir = -1

func on_enter():
	playback.travel("climbing")
	character.local_velocity.y = 0
	# tree.set("parameters/TimeScale/scale", 0)
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
	
	# check which direction to schuut
	if character.sprite.flip_h == true:
		xdir = 1
	else:
		xdir = -1	
	
	#if Input.is_action_pressed("left"):
		#xdir = -1
	#if Input.is_action_pressed("right"):
		#xdir = 1
	
	if Input.is_action_just_pressed("jump"):
		playback.travel("jump")
		if character.ladderjump:
			character.local_velocity.y = character.jump_velocity
		character.climb_buffer = 8
		next_state = air_state
	if Input.is_action_just_pressed("slide"):
		playback.travel("jump")
		character.climb_buffer = 8
		next_state = air_state
	if Input.is_action_pressed("down") && character.is_on_floor():
		playback.travel("idle")
		next_state = ground_state
	if !character.ladder:
		playback.travel("jump")
		next_state = air_state
	if Input.is_action_just_pressed("fire"):
		var fire_funne = 69
		if xdir == 1:
			fire_funne = 0
		elif xdir == -1:
			fire_funne = deg_to_rad(180)
		fire(fire_funne)

		shoot_anim("climb_shoot") # State.gd

	if character.hurt:
		character.hurt = false
		ladder_owie()
	#shoot_anim_timer("climbing_pause") # State.gd
	
func fire(angle):
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(xdir*16, 4)
