extends Node2D
const RATS = preload("res://Scenes/rats.tscn")

var rng = RandomNumberGenerator.new()
var timeofset
func _onready():
	pass
func _on_timer_timeout() -> void:
	timeofset = randi_range(-5, 5)
	# make a rat as chird at a location
	spawn_rat()
	# make timer again
	$Timer.wait_time = timeofset + 15
	$Timer.start()
	pass # Replace with function body.
# every 30sec+ 15-30 as a random timer make a child rat and in the rat it 
# will go zoomies until blah x blah y and then DIE
func spawn_rat():
	# Make an instance of the Rat scene
	var rat = RATS.instantiate()

	# Optional: set position or random offset
	rat.position = Vector2(-120, -52)
	# Add it as a child of this scene
	add_child(rat)


func _on_next_button_pressed() -> void:
	Global.boss_flip = true
	get_tree().change_scene_to_file("res://Scenes/combat.tscn")
