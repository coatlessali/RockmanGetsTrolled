extends CharacterBody2D

# adjustable character vars, tweak to your heart's content
var speed : float = 90
var slide_velocity : float = 150
var friction : float = 5
var local_velocity_cap : float = 250
var jump_velocity : float = -285
var ladderjump : bool = true # enables ladder jumping
var ceilinghit : bool = true # makes it so that when you hit a ceiling you lose momentum

# export vars for other nodes
@export var camera : Camera2D
@export var healthbar : TextureProgressBar
@export var music : AudioStreamPlayer
@onready var hurtsound : AudioStreamPlayer = $Hurt
@onready var charge : AudioStreamPlayer = $Charge
@onready var sprite : Sprite2D = $CharacterSprite
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# vars used for character state etc, do not touch
var hp = 28
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
var weapon = "buster"
var sliding : bool = false

func _ready():
	animation_tree.active = true
	sprite.flip_h = true # the sprite sheet is cursed and flipped
	sprite.material.set("shader_parameter/intensity", 0.0)
	sprite.material.set("shader_parameter/speed", 0.0)

func _physics_process(_delta):
	camera.position.x = move_toward(camera.position.x, cam_pos.x, 4)
	camera.position.y = move_toward(camera.position.y, cam_pos.y, 4)
	if camera.position != cam_pos && !cam_follow_x && !cam_follow_y:
		return
	if hp <= 0:
		dead = true
	healthbar.value = hp
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

func _on_ladder_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("ladders"):
		ladder = true
		ladderpos = area.global_position.x
	if area.is_in_group("CameraTriggers"):
		#cam_pos = area.get_meta("camera_position")
		cam_pos = area.position
		cam_follow_x = false
		cam_follow_y = false
	if area.is_in_group("CameraFollowX"):
		cam_follow_x = true
	if area.is_in_group("CameraFollowY"):
		cam_follow_y = true
func _on_ladder_detection_area_exited(area: Area2D) -> void:
	if area.is_in_group("ladders"):
		ladder = false
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
