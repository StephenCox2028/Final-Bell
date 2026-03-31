extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var warningTimer: Timer = $WarningTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skeletonMusic: AudioStreamPlayer = $SkeletonMusic
@onready var devilMusic: AudioStreamPlayer = $DevilMusic
@onready var exclamationPoint = $"!"
var skeletin = load("res://Scripts/Enemys Scripts/Skeleton.gd").new()# so i can add more later easily
var slime = load("res://Scripts/Enemys Scripts/Slime.gd").new()# so i can add more later easily
var darkiplier = load("res://Scripts/Enemys Scripts/darkiplier.gd").new()
var safe = false # used to detect if blocking or dodging
var enmActions = []

var action : int

func _ready():
	enmActions = [skeletin,slime,darkiplier]#add more latter

	match Global.Boss_counter:
		0: #flame
			action = 1 #800
			change_stats(800,20,2, 4, 2,0)
			animated_sprite_2d.play("TempDefault")
			#Global.currentBoss = "Devil"
			timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
			timer.start()
			devilMusic.play()
			devilMusic.autoplay = true
			pass# same here
		1: #350
			action = 0  #Gets the player low
			change_stats(350,10,3,5,5,0)
			animated_sprite_2d.play("SkeleDefault")# we can change this to be other enemys later
			#Global.currentBoss = "HitManSkeleton"
			timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
			timer.start()
			skeletonMusic.play()
			skeletonMusic.autoplay = true
			pass#change sprites for scertain enemys(reason why their split is also because of the amount of animations in one play would make us depresed)
		#2: 
			#action = 1
			#change_stats(1,20,5, 3, 1,0)
			#animated_sprite_2d.play("TempDefault")
			#Global.currentBoss = "Devil"
			#timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
			#timer.start()
			#devilMusic.play()
			#devilMusic.autoplay = true
			#pass# same here
			
			
		3: #black skeleton
			action = 2 #775 and 3 fuck
			change_stats(1500,20,1, 3.5, 1.5,0)
			animated_sprite_2d.play("blackidle")
			#Global.currentBoss = "Devil"
			timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
			timer.start()
			devilMusic.play()
			devilMusic.autoplay = true
			pass# same here
		4: #1500 and 1
			action = 1
			change_stats(775,90,3, 4.0, 3.0,0)
			animated_sprite_2d.play("TempDefault")
			#Global.currentBoss = "Devil"
			timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
			timer.start()
			devilMusic.play()
			devilMusic.autoplay = true
			pass# same here
			
	
func _on_warning_timer_timeout():
	exclamationPoint.visible = false

func _on_timer_timeout() -> void:	
	exclamationPoint.visible = true
	warningTimer.start()
	enmActions[action].call("Actions", self)
	timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
	timer.start()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Dodge" or anim_name == "Temp Dodge" or anim_name == "blackdodge":
		Global.bosses.dodge = false
	if anim_name == "Block" or anim_name == "Tempblock" or anim_name == "blackblock":
		Global.bosses.block = false

func change_stats(hp,sta,pow,max,min, blckchnce):
	Global.bosses.health 		= hp
	Global.bosses.stamina 		= sta
	Global.bosses.power 		= pow
	Global.bosses.difficultyMax = max
	Global.bosses.difficultyMin = min
	Global.enemy_max 			= hp
	Global.bosses.block_chance=blckchnce
	pass
