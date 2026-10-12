extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var hurtbox = $Hurtbox

var direction = -1
var timer = 180
var shootingtimer = 180
var shooting = false
var onscreen = false

func _ready() -> void:
	sprite.animation = "Idle"


func _physics_process(delta: float) -> void:
	if !onscreen:
		return
	timer -= 1
	if timer <= 0:
		shooting = true
		sprite.animation = "Shoot"
	if shooting:
		shootingtimer -= 1
		if shootingtimer == 150 or shootingtimer == 135 or shootingtimer == 120:
			fire()
		if shootingtimer <= 0:
			sprite.animation = "Idle"
			timer = 180
			shootingtimer = 180
			shooting = false
	move_and_slide()

func fire():
	sprite.play()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	onscreen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	onscreen = false
	sprite.animation = "Idle"
	timer = 180
	shootingtimer = 180
	shooting = false


func _on_hurtbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_hurtbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
