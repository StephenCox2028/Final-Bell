extends Control
@onready var victory_menu: Control = $"."
@onready var score: Label = $Score

func _ready() -> void:
	score.text = str("Score: ",Global.Score)
	Global.boss_flip = false


func _on_next_button_pressed() -> void:
	if (Global.Enemy_tally == 1):
		Global.Enemy_tally = 0
		print(Global.Enemy_tally)
		get_tree().change_scene_to_file("res://Scenes/locker_room.tscn") #switch scenes
	else:
		Global.Enemy_tally = 1
		get_tree().change_scene_to_file("res://Scenes/combat.tscn")#switch scenes
		print(Global.Enemy_tally)
