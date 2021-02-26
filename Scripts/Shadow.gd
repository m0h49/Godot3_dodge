extends RigidBody2D

export var randAnimFrame = "fly"

func _ready():
	$AnimatedSprite.playing = true
	#var shadow_types = $AnimatedSprite.frames.get_animation_names()
	#randAnimFrame = shadow_types[randi() % shadow_types.size()]
	$AnimatedSprite.animation = randAnimFrame
	
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_start_game():
	queue_free()
