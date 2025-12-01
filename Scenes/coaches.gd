extends TextureRect

@onready var denied = $Denied
@onready var transition = $Transition/Transition
@onready var animations = $AnimationPlayer
@onready var levelUp = $LevelUp
@onready var description = $Descriptions


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



func _on_health_button_mouse_entered():
	description.text = "Heal: Heals the player a small amount of health."


func _on_health_button_mouse_exited():
	description.text = ""


func _on_stamina_button_mouse_entered():
	description.text = "Smack: Hits the enemy with a critical hit."


func _on_stamina_button_mouse_exited():
	description.text = ""


func _on_power_button_mouse_entered():
	description.text = "Vision: Allows player to see when enemy is going to strike."


func _on_power_button_mouse_exited():
	description.text = ""


func _on_vamp_button_mouse_entered():
	description.text = "Vampire: Siphons health from enemy."


func _on_vamp_button_mouse_exited():
	description.text = ""
