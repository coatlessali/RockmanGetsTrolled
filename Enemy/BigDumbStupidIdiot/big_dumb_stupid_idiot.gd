extends Boss

func _physics_process(_delta: float) -> void:
	boss_init()

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
