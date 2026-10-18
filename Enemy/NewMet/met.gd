extends CharacterBody2D
const SPEED = 120
var active : bool = false
var state : int = 0
@export var direction : int = -1
var timer : int = 60
var hide_timer : int = 90
var anim_timer : int = 0
var walk_timer : int = 60
var first_anim_timer : int = 0
var onscreen : bool = true
var home_pos : Vector2 = Vector2(0,0)
@onready var sprite : Sprite2D = $MetSprite
@onready var hurtbox : Area2D = $HurtBox
@onready var vosn2d : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var collision : CollisionShape2D = $MetCollision

func _ready() -> void:
	home_pos = position
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta: float) -> void:
	vosn2d.global_position = home_pos
	# Add the gravity.
	if !onscreen:
		return
	if Global.transition:
		sprite.hide()
		return
	else:
		sprite.show()
	if not is_on_floor():
		velocity += get_gravity() * delta
	match state:
		0: # inactive
			velocity.x = 0
			if hide_timer > 0:
				hide_timer -= 1
			elif active:
				state = 1
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
				
			if timer == 56:
				sprite.frame = 2
			if timer == 52:
				sprite.frame = 3
			if timer == 48:
				sprite.frame = 4
			if timer == 36:
				fire(-45)
			if timer == 35:
				fire(0)
			if timer == 34:
				fire(45)
			if timer > 0:
				timer -=1
			else:
				state = 2
			# shooting sprite
			walk_timer = 0
		2: # walking
			hide_timer = 90
			if walk_timer > 0:
				walk_timer -= 1
			else:
				state = 0
				return
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
	var bullet = load("res://Enemy/NewMet/MetBullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
	bullet.direction.x *= direction
	bullet.position = position + Vector2(direction*6, 0)
	get_parent().add_child(bullet)

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if state != 0:
		return
	if body.is_in_group("Player"):
		active = true
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
			explotano.position = position
			get_parent().add_child(explotano)
			sprite.visible = false
			onscreen = false
			hurtbox.set_deferred("monitoring", false) 
			hurtbox.set_deferred("monitorable", false)
			spawn_pickup()

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

func spawn_pickup() -> void:
	var rng = randi_range(1, 128)
	if rng < 78:
		return
	elif rng < 103:
		# replace with small health
		var pickup = load("res://Pickups/HealthSmall.tscn").instantiate()
		pickup.position = position
		get_parent().add_child(pickup)
	elif rng < 118:
		var pickup = load("res://Pickups/AmmoSmall.tscn").instantiate()
		pickup.position = position
		get_parent().add_child(pickup)
	elif rng < 123:
		var pickup = load("res://Pickups/HealthBig.tscn").instantiate()
		pickup.position = position
		get_parent().add_child(pickup)
	elif rng < 127:
		var pickup = load("res://Pickups/AmmoBig.tscn").instantiate()
		pickup.position = position
		get_parent().add_child(pickup)
	else:
		print("1UP")
