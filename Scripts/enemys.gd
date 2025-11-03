extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skeletonMusic: AudioStreamPlayer = $SkeletonMusic
@onready var devilMusic: AudioStreamPlayer = $DevilMusic
var skeletin = load("res://Scripts/Enemys Scripts/Skeleton.gd").new()# so i can add more later easily
var slime = load("res://Scripts/Enemys Scripts/Slime.gd").new()# so i can add more later easily
var safe = false # used to detect if blocking or dodging
var enmActions = []
@export var health = 1
@export var stamina = 1
@export var power = 1


var rng = RandomNumberGenerator.new()
var action : int
var enemy
func _ready():
	enmActions = [skeletin,slime]#add more latter
	enemy = randi_range(1, 2)

	match enemy:
		1:
			action = 0
			change_stats(30,30,30)
			animated_sprite_2d.play("SkeleDefault")# we can change this to be other enemys later
			Global.currentBoss = "Hit-Man Skeleton"
			skeletonMusic.play()
			skeletonMusic.autoplay = true
			pass#change sprites for scertain enemys(reason why their split is also because of the amount of animations in one play would make us depresed)
		2:
			action = 1
			change_stats(90,90,90)
			animated_sprite_2d.play("TempDefault")
			Global.currentBoss = "Devil"
			devilMusic.play()
			devilMusic.autoplay = true
			pass# same here

func _on_timer_timeout() -> void:	
	enmActions[action].call("Actions", self)
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Dodge" or anim_name == "Temp Dodge":
		Global.bosses[Global.currentBoss].dodge = false
	if anim_name == "Block" or anim_name == "Tempblock":
		Global.bosses[Global.currentBoss].block = false
	print(anim_name)

func change_stats(hp,sta,pow):
	Global.playerStats.health = hp
	Global.playerStats.stamina = sta
	Global.playerStats.power = pow
	pass
