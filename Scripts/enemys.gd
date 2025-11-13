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
@export var health = 1
@export var stamina = 1
@export var power = 1

var rng = RandomNumberGenerator.new()
var action : int
var enemy
func _ready():
	enmActions = [skeletin,slime,darkiplier]#add more latter
	enemy = randi_range(1, 2)

	match enemy:
		1:
			action = 0
			change_stats(45,30,10,5.0,5.0)
			animated_sprite_2d.play("SkeleDefault")# we can change this to be other enemys later
			Global.currentBoss = "HitManSkeleton"
			timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
			timer.start()
			skeletonMusic.play()
			skeletonMusic.autoplay = true
			pass#change sprites for scertain enemys(reason why their split is also because of the amount of animations in one play would make us depresed)
		2:
			action = 1
			change_stats(90,90,30, 3.5, 1.5)
			animated_sprite_2d.play("TempDefault")
			Global.currentBoss = "Devil"
			timer.wait_time = randf_range(Global.bosses.difficultyMin, Global.bosses.difficultyMax)
			timer.start()
			devilMusic.play()
			devilMusic.autoplay = true
			pass# same here
		3:
			action = 3
			change_stats(50,90,30, 4.0, 3.0)
			animated_sprite_2d.play("TempDefault")
			Global.currentBoss = "Devil"
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
	if anim_name == "Dodge" or anim_name == "Temp Dodge":
		Global.bosses.dodge = false
	if anim_name == "Block" or anim_name == "Tempblock":
		Global.bosses.block = false

func change_stats(hp,sta,pow,max,min):
	Global.bosses.health 		= hp
	Global.bosses.stamina 		= sta
	Global.bosses.power 		= pow
	Global.bosses.difficultyMax = max
	Global.bosses.difficultyMin = min
	Global.enemy_max 			= hp
	pass
