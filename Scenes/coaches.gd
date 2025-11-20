extends TextureRect

@onready var denied = $Denied
@onready var transition = $Transition/Transition
@onready var animations = $AnimationPlayer
@onready var levelUp = $LevelUp


func _on_health_button_pressed():
	Global.Coach = "angel"
	animations.play("levelUp")
	levelUp.play()

	
func _on_stamina_button_pressed():
	Global.Coach = "self"
	animations.play("grey")
	levelUp.play()

	
func _on_power_button_pressed():
	Global.Coach = "smart"# will make the enemy hp visible
	animations.play("blue")
	levelUp.play()


func _on_back_button_pressed():
	transition.play("fade-out")

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")


func _on_vamp_button_pressed() -> void:
	Global.Coach = "vamp"# will make the enemy hp visible
	animations.play("red")
	levelUp.play()
