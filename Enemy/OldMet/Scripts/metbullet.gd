extends Area2D

@onready var sprite : AnimatedSprite2D = $Sprite2D
@export var visibility : VisibleOnScreenNotifier2D
@export var speed = 125
var deflected : bool = false
var direction = Vector2.RIGHT
var damage = 3

func _ready() -> void:
	sprite.play()

func _process(delta):
	if Global.transition:
		queue_free()
	position = position + speed * direction * delta
	sprite.flip_h = (direction.x == DDirection.LEFT) # flips the sprite if moving left
	#if wallotile:
		#if is_on_floor() or is_on_ceiling() or is_on_wall():
			#pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
