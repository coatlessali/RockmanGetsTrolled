extends CharacterBody2D

# adjustable character vars, tweak to your heart's content
var speed : float = 90
var slide_velocity : float = 140
var friction : float = 5
var local_velocity_cap : float = 250
var jump_velocity : float = -285
var ladderjump : bool = true # enables ladder jumping
var ceilinghit : bool = true # makes it so that when you hit a ceiling you lose momentum

# export vars for other nodes
@export var camera : Camera2D

@export var music : AudioStreamPlayer
@export var facing_direction = 1
@onready var hurtsound : AudioStreamPlayer = $Hurt
@onready var charge : AudioStreamPlayer = $Charge
@onready var sprite : Sprite2D = $CharacterSprite
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# vars used for character state etc, do not touch
var hp = 28
var intro : bool = false
var last_state : State
var input_direction : Vector2
var moving_direction : int = DDirection.RIGHT
var local_velocity : Vector2 = Vector2.ZERO
var environmental_velocity : Vector2 = Vector2.ZERO
var last_faced : int = DDirection.RIGHT
var owie : bool = false
var ladder : bool = false
var ladderdown : bool = false
var ladderpos : float = 0.0
var climbing : bool = false
var climb_buffer = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var shader_intensity = 0.0
var shader_speed = 0.0
var hurt : bool = false
var dead : bool = false
var cam_pos = Vector2(0, 88)
var cam_follow_x : bool = false
var cam_follow_y : bool = false
var sliding : bool = false
var camera_trans : bool = false
var camera_offset : Vector2 = Vector2(0,0)
var going_down : bool = false
var going_right : bool = false

# weapons = buster, resin, shard, sledge, slip, burly
var weapon = "buster"
#var weapons

func _ready():
	animation_tree.active = true
	if facing_direction == 1:
		sprite.flip_h = true # the sprite sheet is cursed and flipped
	else:
		sprite.flip_h = false
	sprite.material.set("shader_parameter/intensity", 0.0)
	sprite.material.set("shader_parameter/speed", 0.0)

func _physics_process(_delta):
	if camera_trans:
		camera.position.x = move_toward(camera.position.x, cam_pos.x, 4)
		camera.position.y = move_toward(camera.position.y, cam_pos.y, 4)
		if camera.position.is_equal_approx(cam_pos):
			camera.position = cam_pos
			camera_trans = false
		if camera.position.y < cam_pos.y:
			position.y += 0.5
		if camera.position.y > cam_pos.y:
			position.y -= 0.5
		if camera.position.x < cam_pos.x:
			position.x += 0.25
		if camera.position.x > cam_pos.x:
			position.x -= 0.25
		return
	if cam_follow_x:
		if position.x > cam_pos.x && going_right:
			camera.position.x = position.x
		if position.x < cam_pos.x && !going_right:
			camera.position.x = position.x
	if cam_follow_y:
		if position.y < cam_pos.y && !going_down:
			camera.position.y = position.y
		if position.y > cam_pos.y && going_down:
			camera.position.y = position.y
			
	if hp <= 0:
		dead = true
	camera.healthbar.value = hp
	input_direction = Input.get_vector("left", "right", "up", "down")
	var x_direction = sign(input_direction.x)
	if x_direction != DDirection.NONE && state_machine.check_if_can_move() && !owie:
		last_faced = x_direction
		#if !is_on_floor():
			#pass
	
	if Input.is_action_just_pressed("fire"):
		charge.play()
	if Input.is_action_just_released("fire"):
		charge.stop()
	
	if Input.is_action_pressed("fire"):
		# charge shot shader
		if shader_intensity < 0.75:
			shader_intensity += 0.0085
		if shader_speed < 10:
			shader_speed += 0.075
	else:
		shader_intensity = 0.0
		shader_speed = 0.0

	#if is_on_floor():
		#pass

	# environmental velocity is controlled by objects in the environment, such as speed boosters, and naturally slows down
	environmental_velocity.x = move_toward(environmental_velocity.x, 0, friction)

	velocity = local_velocity + environmental_velocity
	move_and_slide()
	update_animation(input_direction)
	update_facing_direction(x_direction)
	sprite.material.set("shader_parameter/intensity", shader_intensity)
	sprite.material.set("shader_parameter/speed", shader_speed)

func update_animation(direction):
	animation_tree.set("parameters/Move/blend_position", direction.x)

func update_facing_direction(x_direction):
	if owie:
		return
	if x_direction == DDirection.RIGHT:
		sprite.flip_h = true
	elif x_direction == DDirection.LEFT:
		sprite.flip_h = false

func apply_damage(area: Area2D) -> void:
	if owie:
		return
	if area.is_in_group("EnemyBullet"):
		if sliding && area.is_in_group("Dodge"):
			return
		hp -= area.damage
		hurt = true
		if area.is_in_group("volatile"):
			area.queue_free()

func after_image() -> void:
	var afterimage = load("res://fade.tscn").instantiate()
	afterimage.texture = sprite.texture
	afterimage.position = position
	afterimage.position.y += 6
	afterimage.position.x -= 4
	afterimage.modulate.a = 0.75
	afterimage.modulate.r = 0.1
	afterimage.modulate.g = 0.3
	afterimage.offset = sprite.offset
	afterimage.flip_h = sprite.flip_h
	afterimage.flip_v = sprite.flip_v
	afterimage.hframes = sprite.hframes
	afterimage.vframes = sprite.vframes
	afterimage.frame = sprite.frame
	afterimage.z_index = sprite.z_index-1
	get_parent().add_child(afterimage)
	

func _on_ladder_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("ladders"):
		ladder = true
		ladderpos = area.global_position.x
	if area.is_in_group("CameraTriggers"):
		#cam_pos = area.get_meta("camera_position")
		#cam_pos = area.position
		get_cam_pos(area)
		cam_follow_x = false
		cam_follow_y = false
		camera_trans = true
	if area.is_in_group("CameraFollowX"):
		#cam_pos = area.position
		get_cam_pos(area)
		cam_follow_x = true
		camera_trans = true
	if area.is_in_group("CameraFollowY"):
		#cam_pos = area.position
		get_cam_pos(area)
		cam_follow_y = true
		camera_trans = true
func _on_ladder_detection_area_exited(area: Area2D) -> void:
	if area.is_in_group("ladders"):
		ladder = false
	if area.is_in_group("CameraFollowX"):
		cam_follow_x = false
	if area.is_in_group("CameraFollowY"):
		cam_follow_y = false
		#if area.get_meta("MinimumY"):
			#pass

func get_cam_pos(trigger: Area2D) -> void:
	var temp : float = INF
	for child in trigger.get_children():
		if child.name.contains("Anchor"):
			if global_position.distance_to(child.global_position) < temp:
				temp = global_position.distance_to(child.global_position)
				cam_pos = child.global_position
				if position.y > child.global_position.y:
					going_down = false
				else:
					going_down = true
				if position.x > child.global_position.x:
					going_right = false
				else:
					going_right = true
	
func _on_ladder_detection_down_area_entered(area: Area2D) -> void:
	if area.is_in_group("ladders"):
		ladderdown = true
		ladderpos = area.global_position.x
func _on_ladder_detection_down_area_exited(area: Area2D) -> void:
	if area.is_in_group("ladders"):
		ladderdown = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	apply_damage(area)
func _on_slide_hurtbox_area_entered(area: Area2D) -> void:
	apply_damage(area)
