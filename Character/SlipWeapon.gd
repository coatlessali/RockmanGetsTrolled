extends Weapon

@onready var crosshair : Sprite2D = $Crosshair
@onready var sound : AudioStreamPlayer = $Sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ex = true
	ammo = 28

func fire_weapon(_fire_pos : Vector2, _angle):
	var direction = character.last_faced
	if ammo < 2:
		return
	else:
		ammo -= 2
	crosshair.show()
	crosshair.position = character.position + Vector2(16*direction, 10)
	#crosshair.position.x *= direction
	#var bullet = load("Bullet.tscn").instantiate()
	#bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
	#bullet.position.x = character.position.x + character.last_faced*fire_pos.x
	#bullet.position.y = character.position.y + fire_pos.y
	#bullet.direction.x *= character.last_faced
	#get_parent().add_child(bullet)

func fire_charged_weapon(_fire_pos : Vector2, _angle):
	return

func railshot() -> void:
	pass
