extends Control
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var start_button: Button = $VBoxContainer/StartButton

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://character.tscn")
	pass # place a scene to start here


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
	pass # 


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass #
