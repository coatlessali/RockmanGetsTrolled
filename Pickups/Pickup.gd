extends CharacterBody2D

@export var despawn : bool = true
@export var value : int = 2
@onready var sprite : AnimatedSprite2D = $Sprite

var despawn_timer : int = 600

func _ready() -> void:
	sprite.play()

func _physics_process(delta: float) -> void:
	if despawn:
		despawn_timer -= 1
	if despawn_timer < 240:
		if despawn_timer % 2 == 0:
			sprite.visible = false
		else:
			sprite.visible = true
	if despawn_timer <= 0:
		queue_free()
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
