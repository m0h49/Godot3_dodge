extends RigidBody2D

#warning-ignore-all:unused_class_variable
export var min_speed = 150
export var max_speed = 250
export var randAnimFrame = "fly"

func _ready():
	$AnimatedSprite.playing = true
	#var mob_types = $AnimatedSprite.frames.get_animation_names()
	#randAnimFrame = mob_types[randi() % mob_types.size()]
	$AnimatedSprite.animation = randAnimFrame


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_start_game():
	queue_free()
