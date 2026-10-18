extends Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ex = true
	pass # Replace with function body.


func fire_weapon(_fire_pos : Vector2, _angle):
	if ammo <= 0:
		return
	if get_tree().current_scene.find_child("Rush", true, false):
		return
	ammo -= 4
	#character.camera.ammobar.value = ammo
	var bullet = load("res://Character/rush_coil.tscn").instantiate()
	#bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(angle)).normalized()
	bullet.position.x = character.position.x + character.last_faced*20
	bullet.position.y = character.position.y - 130
	#bullet.direction.x *= character.last_faced
	get_parent().add_child(bullet)

func fire_charged_weapon(_fire_pos : Vector2, _angle):
	if ammo <= 0 or get_tree().current_scene.find_child("Rush", true, false):
		return
	ammo -= 1
	var bullet = load("res://Character/rush_coil.tscn").instantiate()
	bullet.position.x = character.position.x + character.last_faced*20
	bullet.position.y = character.position.y - 130
	bullet.jump_multiplier = 1.8
	get_parent().add_child(bullet)
