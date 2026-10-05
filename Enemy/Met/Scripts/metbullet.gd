extends Area2D

@onready var sprite : Sprite2D = $Sprite2D
@export var visibility : VisibleOnScreenNotifier2D
@export var speed = 200
var deflected : bool = false
var direction = Vector2.RIGHT
var damage = 3

func _ready():
	add_to_group(DGroups.METBULLETS)

func _process(delta):
	for each in get_overlapping_bodies():
		if deflected == false:
			if each.is_in_group("this group might need to exist later but not rn lol"):
				deflected = true
				var random_angle = 2.5
				if randf() < 0.5:
					random_angle = 3.9
				direction = Vector2.RIGHT.rotated(random_angle).normalized()
		else:
			pass
	#print_debug(deflects)
	position = position + speed * direction * delta
	sprite.flip_h = (direction.x == DDirection.LEFT) # flips the sprite if moving left
#some collision detection stuff here

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Deletes bullet if it leaves the screen.
