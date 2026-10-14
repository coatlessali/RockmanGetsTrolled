extends CharacterBody2D
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump_multiplier = 1.6
var timer = 420
var has_touched_floor : bool = false

func _physics_process(delta: float) -> void:
	timer -= 1
	if timer == 390:
		collision.disabled = false
	if not is_on_floor() && timer > 0:
		sprite.frame = 2
		sprite.self_modulate.a += 0.025
		velocity += get_gravity() * delta
	elif timer > 0 && !has_touched_floor:
		sprite.self_modulate.a = 1.0
		sprite.frame = 0
		has_touched_floor = true
	elif timer <= 0:
		velocity -= get_gravity() * delta
		sprite.frame = 2
		sprite.self_modulate.a -= 0.025
		if sprite.self_modulate.a <= 0:
			queue_free()

	move_and_slide()

func _ready() -> void:
	sprite.frame = 2
	sprite.self_modulate.a = 0
	collision.disabled = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && sprite.frame == 0:
		timer = 60
		body.local_velocity.y = body.jump_velocity*jump_multiplier
		sprite.frame = 1
