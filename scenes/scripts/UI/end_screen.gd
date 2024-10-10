extends Control

func _on_button_pressed():
	if get_tree(): get_tree().change_scene_to_file("res://scenes/UI/tittle_screen.tscn")
