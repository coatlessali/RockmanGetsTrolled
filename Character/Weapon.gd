extends Node

class_name Weapon
@export var character : CharacterBody2D
@export var buster : Weapon
var ammo = 28
var ex : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func fire_weapon(_fire_pos : Vector2, _angle):
	pass

func fire_charged_weapon(_fire_pos : Vector2, _angle):
	pass
