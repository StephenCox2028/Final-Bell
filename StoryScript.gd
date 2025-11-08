
extends Sprite2D

func _on_back_button_pressed() -> void: #Is next button didn't change it
	get_tree().change_scene_to_file("res://StoryScene2.tscn")
	pass #
	
