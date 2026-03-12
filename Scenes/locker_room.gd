extends Node2D

@onready var upgradeButton = $Buttons/UpgradeButton
@onready var continueButton = $Buttons/ContinueButton
@onready var quitButton = $Buttons/QuitButton
@onready var character = $SkeletonMain
@onready var animation = $AnimationPlayer
@onready var transition = $Transition/Transition

var choice

const RATS = preload("res://Scenes/rats.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	transition.play("fade-in")
	animation.play("breathing")

func _on_timer_timeout() -> void:
	var timeofset = randi_range(-5, 5)
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
	move_child(rat,8)		#Moves the rat back in the scene tree so transition appears above it.

func _on_upgrade_button_pressed():
	choice = 1
	transition.play("fade-out")
	
func _on_continue_button_pressed():
	Global.resetAllPlayerStats()
	choice = 2
	if Global.Boss_counter == 2 or Global.Boss_counter == 5:
		Global.boss_flip = true
		print(Global.boss_flip)
		print(Global.Boss_counter)
	transition.play("fade-out")

func _on_quit_button_pressed():
	choice = 3
	transition.play("fade-out")

func _on_coaches_button_pressed() -> void:
	choice = 4
	transition.play("fade-out")
	
func _on_transition_animation_finished(anim_name):
		match choice:
			1:
				get_tree().change_scene_to_file("res://Scenes/Upgrade.tscn")
			2:
				get_tree().change_scene_to_file("res://Scenes/combat.tscn")
			3:
				get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
			4:
				get_tree().change_scene_to_file("res://Scenes/Coaches.tscn")
