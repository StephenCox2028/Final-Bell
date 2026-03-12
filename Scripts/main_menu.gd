extends Control
@onready var quit_button: Button = $QuitButton
@onready var options_button: Button = $OptionsButton
@onready var start_button: Button = $StartButton
@onready var story_button: Button = $Story
@onready var transition = $Transition/Transition


var choice
var buttonPressed = false

func _ready():
	transition.play("fade-in")

func _on_start_button_pressed() -> void:	#Connects the start menu .
	if buttonPressed == false:
		buttonPressed = true
		choice = 1
		transition.play("fade-out")
func _on_options_button_pressed() -> void: 
	if buttonPressed == false:
		buttonPressed = true
		choice = 2
		transition.play("fade-out")
func _on_quit_button_pressed() -> void:
	if buttonPressed == false:
		buttonPressed = true
		choice = 3
		transition.play("fade-out")
func _on_story_pressed() -> void:
	if buttonPressed == false:
		buttonPressed = true
		choice = 4
		transition.play("fade-out")


func _on_transition_animation_finished(anim_name):
	match choice:
		1:
			get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")
		2:
			get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
		3:
			get_tree().quit()
		4: 
			get_tree().change_scene_to_file("res://StorySceneOne.tscn")
