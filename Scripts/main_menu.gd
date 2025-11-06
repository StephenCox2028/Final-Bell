extends Control
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var start_button: Button = $VBoxContainer/StartButton


func _on_start_button_pressed() -> void:	#Connects the start menu .
	get_tree().change_scene_to_file("res://Scenes/combat.tscn")
#Both buttons are within the start menu
func _on_options_button_pressed() -> void: 
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
	pass # 

func _on_story_button_pressed() -> void: #Connects to story mode.
	get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")
	pass #

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass #

#func _on_next_button_pressed() -> void #Connects to the intro once next is clicked.
	get_tree().change_sence_to_file("res://Scenes/intro.tscn")
	pass #
	
	#func _on_next_button_pressed() -> void #connects to the locker menu when clicked.
	get_tree().change_sence_to_file("res://Scenes/locker.tscn")
	pass #
	
	#func _on_next_button_pressed() -> void #connects to the combat menu
	get_tree().change_sence_to_file("res://Scenes/combat.tscn")
	pass #
