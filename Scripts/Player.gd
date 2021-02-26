extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Add this variable to hold the clicked position.
var target = Vector2()
var animPlay = false

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position


func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	# Move towards the target and stop when close.
	if position.distance_to(target) > 10:
		velocity = target - position

	if velocity.y < 0:
		$AnimatedSprite.animation = "up"
		$AnimatedShadow.animation = "up"
		$AnimatedSprite.flip_v = false
		$AnimatedShadow.flip_v = false
		if velocity.x > 25:
			$AnimatedSprite.animation = "right"
			$AnimatedShadow.animation = "right"
			$AnimatedSprite.flip_h = false
			$AnimatedShadow.flip_h = false
		elif velocity.x < -25:
			$AnimatedSprite.animation = "right"
			$AnimatedShadow.animation = "right"
			$AnimatedSprite.flip_h = true
			$AnimatedShadow.flip_h = true
	elif velocity.y > 0:
		$AnimatedSprite.animation = "up"
		$AnimatedShadow.animation = "up"
		$AnimatedSprite.flip_v = true
		$AnimatedShadow.flip_v = true
		if velocity.x > 25:
			$AnimatedSprite.animation = "right"
			$AnimatedShadow.animation = "right"
			$AnimatedSprite.flip_h = false
			$AnimatedShadow.flip_h = false
		elif velocity.x < -25:
			$AnimatedSprite.animation = "right"
			$AnimatedShadow.animation = "right"
			$AnimatedSprite.flip_h = true
			$AnimatedShadow.flip_h = true
			
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.playing = true
		$AnimatedShadow.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedShadow.playing = false
		

	position += velocity * delta
	# We still need to clamp the player's position here because on devices that don't
	# match your game's aspect ratio, Godot will try to maintain it as much as possible
	# by creating black borders, if necessary.
	# Without clamp(), the player would be able to move under those borders.
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func start(pos):
	position = pos
	# Initial target is the start position.
	target = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
