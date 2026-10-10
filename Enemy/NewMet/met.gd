extends CharacterBody2D
const SPEED = 120
var active : bool = false
var state : int = 0
@export var direction : int = -1
var timer : int = 60
var anim_timer : int = 0
var walk_timer : int = 60
var first_anim_timer : int = 0
var onscreen : bool = true
var home_pos : Vector2 = Vector2(0,0)
@onready var sprite : Sprite2D = $MetSprite
@onready var hurtbox : Area2D = $HurtBox
@onready var collision : CollisionShape2D = $MetCollision

func _ready() -> void:
	home_pos = position
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !onscreen:
		return
	if Global.transition:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	match state:
		0: # inactive
			velocity.x = 0
			if sprite.frame != 0:
				if sprite.frame == 7:
					sprite.frame = 8
				elif sprite.frame == 8:
					sprite.frame = 9
				elif sprite.frame == 9:
					sprite.frame = 10
				elif sprite.frame == 10:
					sprite.frame = 11
				elif sprite.frame == 11:
					sprite.frame = 0
				else:
					sprite.frame = 7
			else:
				sprite.frame = 0
				timer = 60
			# hiding sprite
		1: # shooting
			if timer == 60:
				sprite.frame = 1
				fire(-30)
				fire(0)
				fire(30)
			if timer == 56:
				sprite.frame = 2
			if timer == 52:
				sprite.frame = 3
			if timer == 48:
				sprite.frame = 4
			if timer > 0:
				timer -=1
			else:
				state = 2
			# shooting sprite
			walk_timer = 60
		2: # walking
			if walk_timer > 0:
				walk_timer -= 1
			else:
				state = 0
			if anim_timer == 0:
				sprite.frame = 5
			if anim_timer == 4:
				sprite.frame = 6
			if anim_timer == 8:
				anim_timer = -1
			anim_timer += 1
			velocity.x = SPEED * direction
		_:
			pass

	move_and_slide()

func fire(angle):
	print("angle: " + str(angle))
	var bullet = load("res://Enemy/OldMet/MetBullet.tscn").instantiate()
	get_parent().add_child(bullet)
	bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
	bullet.direction.x *= direction
	bullet.position = position + Vector2(direction*6, 0)

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if state != 0:
		return
	if body.is_in_group("Player"):
		state = 1
		if body.global_position > global_position: # if player is to the right
			direction = 1 # turn it right
			sprite.flip_h = true
		else: # if player is to the left
			direction = -1 # turn it left
			sprite.flip_h = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	hurtbox.set_deferred("monitoring", false) 
	hurtbox.set_deferred("monitorable", false) 
	#collision.disabled = true
	onscreen = false
	position = home_pos

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		if area.is_in_group("volatile"):
			if state == 0:
				var random_angle = 2.5
				if randf() < 0.5:
					random_angle = 3.9
				area.direction = Vector2(1.0,0.0).rotated(random_angle).normalized()
				#area.sprite.flip_h = !area.sprite.flip_h
			else:
				area.queue_free() # despawn player bullet
		if state != 0:
			var explotano = load("res://explotano.tscn").instantiate()
			get_parent().add_child(explotano)
			explotano.position = position
			sprite.visible = false
			onscreen = false
			hurtbox.set_deferred("monitoring", false) 
			hurtbox.set_deferred("monitorable", false) 
			#queue_free() # despawn met (kill it)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	hurtbox.set_deferred("monitoring", true) 
	hurtbox.set_deferred("monitorable", true) 

	onscreen = true
	active = false
	state = 0
	direction = -1
	timer = 60
	anim_timer = 0
	walk_timer = 60
	first_anim_timer = 0
	sprite.visible = true
