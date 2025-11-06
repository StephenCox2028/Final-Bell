extends Control


func _on_retry_pressed() -> void:
	Global.resetAllPlayerStats()
	Global.resetAllEnemyStats()
	get_tree().change_scene_to_file("res://Scenes/combat.tscn")
	pass # 

func _on_die_pressed() -> void:
	get_tree().quit()
	pass #
