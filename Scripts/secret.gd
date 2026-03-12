extends Node2D

@onready var transition = $Transition/Transition
@onready var textEdit = $TextEdit
@onready var exitButton = $ExitButton
@onready var submit = $Submit
@onready var label = $Label

var password = "passwordTesting"

func _ready():
	transition.play("fade-in")

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")

func _on_submit_pressed():
	if textEdit.text == password:
		label.text = "Enabled DEBUG Mode"
		label.modulate = "00b12c"
		Global.secretEnabled = true
	else:
		label.modulate = "ff4233"	
		label.text = "Incorrect Password"
	textEdit.text = ""

func _on_text_edit_text_changed():
	if "\n" in textEdit.text:
		textEdit.text = textEdit.text.replace("\n", "")
		# Move cursor to end to prevent weird behavior
		textEdit.set_caret_line(0)
		textEdit.set_caret_column(textEdit.text.length())
