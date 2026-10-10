extends CharacterBody2D
const SPEED = 200
var active : bool = false
var state : int = 0
@export var direction : int = -1
var timer : int = 60
var anim_timer : int = 0
var walk_timer : int = 60
var first_anim_timer : int = 0
@onready var sprite : Sprite2D = $MetSprite
@onready var hurtbox : Area2D = $HurtBox
@onready var collision : CollisionShape2D = $MetCollision
@onready var vosn2d : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
var onscreen : bool = false
var home_pos : Vector2 = Vector2(0, 0)

func _ready() -> void:
	home_pos = position
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta: float) -> void:
	#vosn2d.global_position = home_pos
	# Add the gravity.
	if !onscreen:
		#print(onscreen)
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	#print(state)
	match state:
		0: # inactive
			velocity.x = 0
			sprite.frame = 4
			timer = 1
			sprite.offset.x = randf_range(-1, 1)
			#sprite.offset.y = randf_range(-0.25, 0.25)
			# hiding sprite
		1: # shooting
			if timer == 60:
				sprite.offset = Vector2(0.0, 0.0)
				sprite.frame = 1
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
			if sprite.self_modulate.b > 0:
				sprite.self_modulate.b -= 0.025
				sprite.self_modulate.g -= 0.025
			if walk_timer == 50:
				velocity.y -= 200 # jump height
				sprite.frame = 7
				sprite.rotation_degrees = -90
			if walk_timer < 50:
				sprite.offset.x = randf_range(-1, 1)
				sprite.offset.y = randf_range(-1, 1)
			if walk_timer > 0:
				walk_timer -= 1
			if is_on_floor() or is_on_ceiling() or is_on_wall():
				if walk_timer < 49:
					fire(45)
					fire(90)
					fire(135)
					fire(180)
					fire(225)
					fire(270)
					fire(315)
					fire(360)
					var explotano = load("res://explotano.tscn").instantiate()
					get_parent().add_child(explotano)
					explotano.position = position
					sprite.visible = false
					onscreen = false
					hurtbox.set_deferred("monitoring", false) 
					hurtbox.set_deferred("monitorable", false)
					sprite.rotation_degrees = 0
					sprite.self_modulate.b = 1
					sprite.self_modulate.g = 1
			velocity.x = SPEED * direction
		_:
			pass

	move_and_slide()

func fire(angle):
	print("angle: " + str(angle))
	var bullet = load("res://Enemy/OldMet/MetBullet.tscn").instantiate()
	get_parent().add_child(bullet)
	bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
	bullet.speed = 500
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
	onscreen = false
	position = home_pos
	#vosn2d.global_position = home_pos

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		if area.is_in_group("volatile"):
			#if state == 0:
				#var random_angle = 2.5
				#if randf() < 0.5:
				#random_angle = 3.9
				#area.direction = Vector2(1.0,0.0).rotated(random_angle).normalized()
				#area.sprite.flip_h = !area.sprite.flip_h
			#else:
			area.queue_free() # despawn player bullet
		#if state != 0:
		var explotano = load("res://explotano.tscn").instantiate()
		get_parent().add_child(explotano)
		explotano.position = position
		sprite.visible = false
		onscreen = false
		hurtbox.set_deferred("monitoring", false) 
		hurtbox.set_deferred("monitorable", false)
		sprite.rotation_degrees = 0
		sprite.self_modulate.b = 1
		sprite.self_modulate.g = 1

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
