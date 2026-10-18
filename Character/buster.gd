extends Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo = 28

func fire_weapon(fire_pos : Vector2, angle):
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
	bullet.position.x = character.position.x + character.last_faced*fire_pos.x
	bullet.position.y = character.position.y + fire_pos.y
	bullet.direction.x *= character.last_faced
	get_parent().add_child(bullet)

func fire_charged_weapon(fire_pos : Vector2, angle):
	var bullet = load("res://ChargeBullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
	bullet.position.x = character.position.x + character.last_faced*fire_pos.x
	bullet.position.y = character.position.y + fire_pos.y
	bullet.direction.x *= character.last_faced
	get_parent().add_child(bullet)
