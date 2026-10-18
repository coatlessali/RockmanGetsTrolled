extends Weapon

@onready var sound : AudioStreamPlayer = $Sound
var reloading : bool = false

func fire_weapon(fire_pos : Vector2, angle):
	if ammo <= 13 or reloading:
		reloading = true
		return
	ammo -= 14
	character.camera.ammobar.value = ammo
	sound.play()
	var loop_count = 14
	while loop_count > 0:
		spawn_bullet(fire_pos, angle)
		loop_count -= 1

func spawn_bullet(fire_pos : Vector2, angle):
	var bullet = load("Bullet.tscn").instantiate()
	var rand_angle = randf_range(-45.0, 45.0)
	#bullet.sprite.rotation_degrees = rand_angle
	bullet.expire = 0
	bullet.limit = false
	bullet.autoplay = false
	bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle + rand_angle)).normalized()
	bullet.position.x = character.position.x + character.last_faced*fire_pos.x
	bullet.position.y = character.position.y + fire_pos.y
	bullet.direction.x *= character.last_faced
	bullet.speed = randf_range(100.0, 600.0)
	get_parent().add_child(bullet)
	bullet.sprite.texture = load("res://Art/rock/mega_shell.png")

func fire_charged_weapon(fire_pos : Vector2, angle):
	if ammo < 28 or reloading:
		fire_weapon(fire_pos, angle)
		return
	reloading = true
	ammo -= 28
	character.camera.ammobar.value = ammo
	sound.play()
	var loop_count = 28
	while loop_count > 0:
		spawn_bullet(fire_pos, angle)
		loop_count -= 1


func _on_sound_finished() -> void:
	reloading = false
