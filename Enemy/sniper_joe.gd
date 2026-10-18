extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var vosn2d : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var direction = -1
var timer = 120
var shootingtimer = 180
var shooting = false
var onscreen = false
var home_pos = Vector2(0, 0)
var hp = 10

func _ready() -> void:
	if direction == -1:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	sprite.animation = "Idle"
	home_pos = position
	


func _physics_process(_delta: float) -> void:
	if !onscreen:
		return
	if Global.transition:
		sprite.hide()
		return
	else:
		sprite.show()
	timer -= 1
	if timer <= 0:
		shooting = true
		sprite.animation = "Shoot"
	if shooting:
		shootingtimer -= 1
		if shootingtimer == 150 or shootingtimer == 125 or shootingtimer == 100:
			fire()
		if shootingtimer <= 0:
			sprite.animation = "Idle"
			timer = 180
			shootingtimer = 180
			shooting = false
	move_and_slide()

func fire():
	sprite.play()
	var bullet = load("res://Enemy/NewMet/MetBullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.normalized()
	bullet.direction.x *= direction
	bullet.position = position + Vector2(direction*9, 4)
	bullet.speed = 120
	get_parent().add_child(bullet)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	onscreen = true
	hurtbox.set_deferred("monitoring", true) 
	hurtbox.set_deferred("monitorable", true)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	onscreen = false
	sprite.animation = "Idle"
	timer = 180
	shootingtimer = 180
	shooting = false
	hurtbox.set_deferred("monitoring", false) 
	hurtbox.set_deferred("monitorable", false)
	position = home_pos
	hp = 10


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		if shooting:
			hp -= area.damage
			print(hp)
			print(area.damage)
			if hp <= 0:
				spawn_pickup()
				var explotano = load("res://explotano.tscn").instantiate()
				explotano.position = position
				get_parent().add_child(explotano)
				sprite.visible = false
				onscreen = false
				sprite.animation = "Idle"
				timer = 180
				shootingtimer = 180
				shooting = false
				hurtbox.set_deferred("monitoring", false) 
				hurtbox.set_deferred("monitorable", false)
				position = home_pos
				hp = 10
		if area.is_in_group("volatile"):
			if !shooting:
				# TODO: come back to this later and just =* direction.x
				var random_angle = 2.5
				if randf() < 0.5:
					random_angle = 3.9
				area.direction = Vector2(1.0,0.0).rotated(random_angle).normalized()
			else:
				area.queue_free() # despawn player bullet


func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.position.x < position.x:
			sprite.flip_h = false
			direction = -1
		else:
			sprite.flip_h = true
			direction = 1

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
