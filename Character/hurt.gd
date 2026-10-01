extends State

var hurt_timer = 90
@export var ground_state : State
@export var air_state : State
@export var slide_state : State
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	print("still going")

func on_enter():
	character.local_velocity.y = 0
	hurt_timer = 45
	character.owie = true
	pass

func on_exit():
	character.owie = false

func state_process(_delta, _direction):
	if hurt_timer > 0:
		hurt_timer -= 1
		if not character.is_on_floor():
			if character.local_velocity.y < character.gravity:
				character.local_velocity.y += character.gravity * _delta
		if !slidecast.is_colliding():
			character.local_velocity.x = -character.last_faced*character.speed/4
		else:
			character.local_velocity.x = 0
	else:
		if character.is_on_floor():
			if slidecast.is_colliding():
				playback.travel("slide")
				next_state = slide_state
			else:
				playback.travel("idle")
				next_state = ground_state
		else:
			playback.travel("jump")
			next_state = air_state
