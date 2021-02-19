extends Node

export(PackedScene) var mob_scene
export(PackedScene) var shadow_scene

var score
var load_score

func _ready():
	# Load score
	var file = File.new()
	if file.file_exists("user://savescore.save"):
		file.open("user://savescore.save", File.READ)
		load_score = parse_json(file.get_as_text())
		file.close()
		print(load_score)
	else:
		printerr("No saved score!")
		
	$HUD/MarginContainer/VBoxContainer/ScoreLabel.text = str(load_score)
		
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
	if score > load_score:
		# Save score
		var save_score = File.new()
		save_score.open("user://savescore.save", File.WRITE)
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
	$Music.play()


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	var shadow = shadow_scene.instance()
	add_child(shadow)
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	add_child(mob)

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	shadow.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

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
