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
		buster.fire_weapon(_fire_pos, _angle)
		return
	else:
		ammo -= 2
	crosshair.show()
	crosshair.position = character.position + Vector2(16*direction, 10)

func fire_charged_weapon(_fire_pos : Vector2, _angle):
	buster.fire_charged_weapon(_fire_pos, _angle)
