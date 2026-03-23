extends Sprite2D
@onready var timer: Timer =$Timer
func _ready():
	timer.start(10)
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/combat.tscn")
