extends Area2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var visibility : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sound : AudioStreamPlayer = $AudioStreamPlayer
var autoplay = true
var deflected : bool = false
var direction = Vector2(1.0,0.0)
var speed = 300.0
var expire = 120
var fade_speed = 0.05
var damage = 1
var limit = true

func _ready():
	# force right direction
	var default = direction 
	direction.x = -Input.get_action_strength("left") + Input.get_action_strength("right")
	direction.y = -Input.get_action_strength("up") + Input.get_action_strength("down")
	if direction == Vector2.ZERO:
		direction = default
	sprite.rotation = direction.angle()
	if autoplay:
		sound.play()
	sound.reparent(get_parent())

func _physics_process(delta: float) -> void:
	position += speed * direction * delta
	expire -= 1
	if expire <= 0:
		if sprite.self_modulate.a > 0:
			sprite.self_modulate.a -= fade_speed
		else:
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
