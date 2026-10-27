extends Node2D

@onready var door_body : StaticBody2D = $DoorBody
@onready var open_sound : AudioStreamPlayer = $Open
@onready var close_sound : AudioStreamPlayer = $Close

#var open_has_played : bool = false
#var close_has_played : bool = false
var open : bool = false
var closed_pos = Vector2.ZERO
var open_pos = Vector2(0, -32)
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.find_child("Player", true, false)
	closed_pos = door_body.position
	open_pos = door_body.position + Vector2(0, -32)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Global.transition:
		return
	if player.camera_trans:
		return
	if open:
		if door_body.position.y == closed_pos.y:
			open_sound.play()
		door_body.position.y = move_toward(door_body.position.y, open_pos.y, 1)
	else:
		if door_body.position.y == open_pos.y:
			close_sound.play()
		door_body.position.y = move_toward(door_body.position.y, closed_pos.y, 1)


func _on_door_open_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		open = true


func _on_door_close_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		open = false
