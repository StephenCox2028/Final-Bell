extends Control

func _on_die_pressed() -> void:
	Global.dead()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
