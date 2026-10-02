extends AnimationTree

@export var state_machine : CharacterStateMachine
@export var player : CharacterBody2D
var shoot : int = 0

func _physics_process(_delta):
	if Input.is_action_just_pressed("fire"):
		shoot = 60
	if shoot > 0:
		shoot -= 1
