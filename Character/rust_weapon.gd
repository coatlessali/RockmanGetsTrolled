extends Weapon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo = 28


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire_weapon(fire_pos : Vector2, angle):
	if ammo > 0:
		ammo -= 0.5
		var bullet = load("Nail.tscn").instantiate()
		bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
		bullet.position.x = character.position.x + character.last_faced*fire_pos.x
		bullet.position.y = character.position.y + fire_pos.y
		bullet.direction.x *= character.last_faced
		get_parent().add_child(bullet)

func fire_charged_weapon(_fire_pos : Vector2, _angle):
	fire_weapon(_fire_pos, _angle)
