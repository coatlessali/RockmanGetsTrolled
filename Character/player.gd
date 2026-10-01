extends CharacterBody2D

@export var camera : Camera2D
@export var speed : float = 90
@export var slide_velocity : float = 150
@export var friction : float = 5
@export var local_velocity_cap : float = 250
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@export var jump_velocity : float = -255
var last_state : State
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var input_direction : Vector2
var local_velocity : Vector2 = Vector2.ZERO
var environmental_velocity : Vector2 = Vector2.ZERO
var moving_direction : int = DDirection.RIGHT
var last_faced : int = DDirection.RIGHT
var owie : bool = false
var shader_intensity = 0.0
var shader_speed = 0.0

func _ready():
	print_debug("i was never book smart, im money smart")
	animation_tree.active = true
	sprite.flip_h = true
	sprite.material.set("shader_parameter/intensity", 0.0)
	sprite.material.set("shader_parameter/speed", 0.0)

func _physics_process(_delta):
	# print_debug("player.gd: ", last_faced)
	input_direction = Input.get_vector("left", "right", "up", "down")
	# unused, might be useful later
	var x_direction = sign(input_direction.x)
	if x_direction != DDirection.NONE && state_machine.check_if_can_move() && !owie:
		last_faced = x_direction
		if !is_on_floor():
			pass
	
	if Input.is_action_pressed("fire"):
		if shader_intensity < 0.5:
			shader_intensity += 0.005
		print(shader_intensity)
		if shader_speed < 10:
			shader_speed += 0.075
		print(shader_speed)
	else:
		shader_intensity = 0.0
		shader_speed = 0.0

	if is_on_floor():
		pass

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

func _on_death_box_of_doom_body_entered(body):
	print_debug("Entered!")
	position.x = 0
	position.y = 0

func _on_camera_y_trigger_body_entered(body):
	print_debug("Entered!")
	camera.follow_y = true


func _on_camera_y_trigger_body_exited(body):
	camera.follow_y = false
