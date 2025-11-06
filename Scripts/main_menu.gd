extends Control
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var transition = $Transition/Transition

var choice

func _ready():
	transition.play("fade-in")

func _on_start_button_pressed() -> void:	#Connects the start menu .
	choice = 1
	transition.play("fade-out")
func _on_options_button_pressed() -> void: 
	choice = 2
	transition.play("fade-out")
func _on_quit_button_pressed() -> void:
	choice = 3
	transition.play("fade-out")

func _on_transition_animation_finished(anim_name):
	match choice:
		1:
			get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")
		2:
			get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
		3:
			get_tree().quit()
