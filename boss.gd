extends CharacterBody2D
class_name Boss
var health = 28
var camera : Camera2D
var enabled = false
var refill_timer = 0
var player : CharacterBody2D
@onready var refill = $Refill



func _ready() -> void:
	camera = get_tree().current_scene.find_child("Camera2D", true, false)
	player = get_tree().current_scene.find_child("Player", true, false)

func boss_init() -> void:
	if player.camera_trans:
		return
	if !enabled:
		return
	if health > camera.bosshealthbar.value:
		if refill_timer == 0:
			camera.bosshealthbar.value += 1
			refill.play()
		if refill_timer == 3:
			refill_timer = 0
		else:
			refill_timer += 1
		Global.boss_trans = true
	else:
		camera.bosshealthbar.value = health
		Global.boss_trans = false

func _physics_process(_delta: float) -> void:
	boss_init()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	camera.bossframe.show()
	enabled = true
