extends Node

export(PackedScene) var mob_scene
export(PackedScene) var shadow_scene

const FILE_NAME = "user://savescore.save"

var score
var load_score
var mob_types = [ "fly", "swim", "walk"]

func _ready():
	$Background/AnimationPlayer.play("BackgroundAnim")
	# Load score
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		load_score = parse_json(file.get_as_text())
		file.close()
	else:
		printerr("No saved score!")
		load_score = 0
		
	randomize()
	$HUD/MarginContainer/VBoxContainer/ScoreLabel.text = str(load_score)


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	if $DeathSound.stream_paused == false:
		$DeathSound.play()
	
	if score > load_score:
		# Save score
		var save_score = File.new()
		save_score.open(FILE_NAME, File.WRITE)
		save_score.store_string(to_json(score))
		save_score.close()
		
		load_score = score
		

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	if $Music.stream_paused == false:
		$Music.play()


func _on_MobTimer_timeout():
	var randAnim = mob_types[randi() % mob_types.size()]
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	var shadow = shadow_scene.instance()
	shadow.randAnimFrame = randAnim
	add_child(shadow)
	
	# Create a Mob instance and add it to the scene.
	
	var mob = mob_scene.instance()
	mob.randAnimFrame = randAnim
	add_child(mob)
	
	
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	shadow.position = mob_spawn_location.position
	shadow.position.x = shadow.position.x + 15
	shadow.position.y = shadow.position.y + 15

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	shadow.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)
	shadow.linear_velocity = velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
