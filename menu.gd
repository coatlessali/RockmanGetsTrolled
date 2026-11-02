extends Node2D

@onready var menu : Node2D = $Menu
@onready var buster = $Menu/BusterBar
@onready var rush = $Menu/RushBar
@onready var resin = $Menu/ResinBar
@onready var sledge = $Menu/SledgeBar
@onready var rust = $Menu/RustBar
@onready var slip = $Menu/SlipBar
@onready var burly = $Menu/BurlyBar
@onready var weapons : Array[TextureProgressBar] = [buster, rush, resin, sledge, rust, slip, burly]
var weapon_num = 0
var weapon_max = 0

@export var menu_speed : float = 16.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().paused:
		menu.position.y = 0
	else:
		menu.position.y = 240
	weapon_max = weapons.size() - 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		if get_tree().paused:
			var player = get_parent().character
			player.weapon_num = weapon_num
			# incredibly dumb thing that forces the weapon to refresh
			player.cycle_weapon(true)
			player.cycle_weapon(false)
		else:
			update_ammo()
		get_tree().paused = !get_tree().paused
		if !get_tree().paused:
			Input.action_release("fire")
	if get_tree().paused:
		if Input.is_action_just_pressed("down"):
			weapon_num += 1
			if weapon_num > weapon_max:
				weapon_num = 0
		if Input.is_action_just_pressed("up"):
			weapon_num -= 1
			if weapon_num < 0:
				weapon_num = weapon_max
		if Input.is_action_just_pressed("left"):
			weapon_num = 0
		if Input.is_action_just_pressed("right"):
			weapon_num = weapon_max
		for weapon in weapons:
			weapon.get_node("Label").modulate.g = 1.0
			weapon.get_node("Label").modulate.b = 1.0
		weapons[weapon_num].get_node("Label").modulate.g = 0.25
		weapons[weapon_num].get_node("Label").modulate.b = 0.25
		menu.position.y = move_toward(menu.position.y, 0, menu_speed)
	else:
		menu.position.y = move_toward(menu.position.y, 240, menu_speed)
	

func update_ammo() -> void:
	var current = 0
	for weapon in weapons:
		weapon.value = get_parent().character.weapons[current].ammo
		current += 1
	weapon_num = get_parent().character.weapon_num
