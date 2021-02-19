extends CanvasLayer

signal start_game

func show_message(text):
	$MarginContainer/VBoxContainer/MessageLabel.text = text
	$MarginContainer/VBoxContainer/MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MarginContainer/VBoxContainer/MessageLabel.text = "Dodge the\nCreeps"
	$MarginContainer/VBoxContainer/MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$MarginContainer/VBoxContainer/StartButton.show()
	$MarginContainer/VBoxContainer/SettingButton.show()
	$MarginContainer/VBoxContainer/Quit.show()


func update_score(score):
	$MarginContainer/VBoxContainer/ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$MarginContainer/VBoxContainer/StartButton.hide()
	$MarginContainer/VBoxContainer/SettingButton.hide()
	$MarginContainer/VBoxContainer/Quit.hide()
	emit_signal("start_game")

func _on_SettingButton_pressed():
	$MarginContainer.hide()
	get_node("../Setting/MarginContainer").show()
	
func _on_MessageTimer_timeout():
	$MarginContainer/VBoxContainer/Label.hide()
	$MarginContainer/VBoxContainer/MessageLabel.hide()

func _on_Quit_pressed():
	get_tree().quit()
