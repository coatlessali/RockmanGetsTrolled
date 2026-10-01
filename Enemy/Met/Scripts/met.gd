extends CharacterBody2D

@export var speed : float = 120
@export var speed_delta : float = 60
@export var active_box : CollisionShape2D
@export var sprite : Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@export var sound : AudioStreamPlayer2D
@export var hp : int = 1
@export var bullets_max : int = 3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var moving_direction : int = DDirection.RIGHT
var facing : int = DDirection.LEFT
var state = DStates.INACTIVE
var inactive_timer = 60
var active_timer = 20
var delay_timer = 30
var bullets_fired : int = 0

func _ready():
	#animation_tree.active = true
	pass

func _physics_process(_delta):
	if hp <= 0:
		queue_free()
	if facing == DDirection.RIGHT:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	match state:
		DStates.ACTIVE:
			if inactive_timer > 0:
				inactive_timer -= 1
				return
			else:
				remove_from_group(DGroups.DEFLECT)
				add_to_group(DGroups.ENEMY)
				if facing == DDirection.RIGHT:
					speed = speed_delta
				else:
					speed = -speed_delta
				if bullets_fired >= bullets_max:
					if delay_timer > 0:
						delay_timer -= 1
					else:
						state = DStates.INACTIVE
						delay_timer = 0
				else:
					if active_timer > 0:
						active_timer -=1
					else:
						fire(PI)
						bullets_fired += 1
						active_timer = 20
		DStates.INACTIVE:
			remove_from_group(DGroups.ENEMY)
			add_to_group(DGroups.DEFLECT)
		_:
			pass

	if is_on_floor():
		pass
	else:
		velocity.y += gravity

	move_and_slide()



func _on_area_2d_body_entered(body):
	if body.is_in_group(DGroups.PLAYER):
		print_debug("eek!")
		if body.position.x <= position.x:
			print_debug("left")
			facing = DDirection.LEFT
		else:
			print_debug("right")
			facing = DDirection.RIGHT
		inactive_timer = 60
		active_timer = 20
		delay_timer = 30
		state = DStates.ACTIVE
		sound.play(0)


func _on_hurtbox_area_entered(area):
	if area.is_in_group(DGroups.BULLETS) and state == DStates.ACTIVE:
		hp -= 1

func fire(angle):
	var bullet = load("res://Enemy/Met/MetBullet.tscn").instantiate()
	get_parent().add_child(bullet)
	bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
	bullet.position = position + Vector2(facing*1, 0)
