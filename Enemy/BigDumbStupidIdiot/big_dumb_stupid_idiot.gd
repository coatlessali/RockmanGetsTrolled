extends CharacterBody2D
var health = 28
var camera : Camera2D
var enabled = false
var refill_timer = 0
var player : CharacterBody2D
@onready var refill = $Refill

func _ready() -> void:
	camera = get_tree().current_scene.find_child("Camera2D", true, false)
	visible = true
	player = get_tree().current_scene.find_child("Player", true, false)

func _physics_process(_delta: float) -> void:
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

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		if area.is_in_group("volatile"):
			area.queue_free() # despawn player bullet
		health -= area.damage
		if health <= 0:
			var explotano = load("res://explotano.tscn").instantiate()
			get_parent().add_child(explotano)
			explotano.position = position
			explotano.scale = Vector2(3, 3)
			explotano.sound.volume_db = 0.0
			camera.bossframe.hide()
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	camera.bossframe.show()
	enabled = true
