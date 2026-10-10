extends CharacterBody2D
var health = 50

func _ready() -> void:
	visible = true

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		if area.is_in_group("volatile"):
			area.queue_free() # despawn player bullet
		health -= 1
		if health <= 0:
			var explotano = load("res://explotano.tscn").instantiate()
			get_parent().add_child(explotano)
			explotano.position = position
			explotano.scale = Vector2(3, 3)
			explotano.sound.volume_db = 0.0
			queue_free()
