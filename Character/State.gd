extends Node

class_name State

@export var character : CharacterBody2D
@export var hurtbox : CollisionShape2D
@export var hurtbox_sprite : Sprite2D
@export var slide_hurtbox : CollisionShape2D
@export var actual_hurtbox: Area2D
@export var slide_actual_hurtbox : Area2D
@export var slidecast : ShapeCast2D
@export var hurt : State
@export var climb_hurt : State
var next_state : State
var last_state : State
@export var can_move : bool = true
var playback : AnimationNodeStateMachinePlayback
#@onready var state_machine : CharacterStateMachine = $MetStateMachine

var shoot_timer : int = 0

# set up processes for other states to inherit

func state_process(_delta, _direction):
	pass

func state_input(_event : InputEvent):
	pass

# what to do when the state is entered
func on_enter():
	pass

# what to do when the state is exited
func on_exit():
	pass

func owie():
	character.hurt = false
	playback.travel("hurt")
	next_state = hurt

func ladder_owie():
	character.hurt = false
	playback.travel("climb_hurt")
	next_state = climb_hurt

# Forces a number to be converted to negative
func force_negative(nval):
	if nval < 0:
		return nval
	elif nval > 0:
		return nval*-1

# Forces a number to be converted to positive
func force_positive(pval):
	if pval < 0:
		return pval*-1
	elif pval > 0:
		return pval

func shoot_anim_timer(anim):
	# this is so fucking dumb oh my god why could i not find any results on how to use the fucking advance_condition() this might actually be the worst code i've ever written
	if shoot_timer > 0:
		shoot_timer -= 1
	#print_debug(shoot_timer)
	if shoot_timer == 0:
		playback.travel(anim)

func shoot_anim(anim):
	# stupid dumb shoot animation
	shoot_timer = 20
	playback.travel(anim)
