extends Area2D

@onready var sprite : Sprite2D = $Sprite2D
@export var visibility : VisibleOnScreenNotifier2D
var deflected : bool = false
var direction = Vector2(1.0,0.0)
var speed = 300.0
#var speed = 10 # for testing
var expire = 120
var damage = 1

func _ready():
	add_to_group(DGroups.BULLETS)
	var bullets = get_tree().get_nodes_in_group(DGroups.BULLETS)
	if bullets.size() > 3: # Why the fuck does this need to be a 4???
		queue_free()
	#print_debug(bullets.size()-1) # Account for the weird er... counting.
	
#some collision detection stuff here

func _physics_process(delta: float) -> void:
	# make sure bullets despawn after no more than 2 seconds
	if expire > 0:
		expire -= 1
	else:
		if sprite.self_modulate.a > 0: # fade out
			sprite.self_modulate.a -= 0.05
		else:
			queue_free()
	position = position + speed * direction * delta
	sprite.flip_h = (direction.x == -1.0) # flips the sprite if moving left

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Deletes bullet if it leaves the screen.
