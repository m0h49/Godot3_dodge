extends CanvasLayer

func _on_BackButton_pressed():
	$MarginContainer.hide()
	get_node("../HUD/MarginContainer").show()

func _on_MusicCheckButton_pressed():
	get_node("../Music").stream_paused = true
	
func _on_SoundCheckButton_pressed():
	get_node("../DeathSound").stream_paused = true
	
