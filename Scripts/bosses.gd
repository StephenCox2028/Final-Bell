extends Node2D

signal boss_banner(number: int)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var warningTimer: Timer = $WarningTimer
@onready var skeletonMusic: AudioStreamPlayer = $SkeletonMusic
@onready var devilMusic: AudioStreamPlayer = $DevilMusic
@onready var exclamationPoint = $"!"
@onready var pictures: Node2D = $pictures

	#examples for bosses
#var skeletin = load("res://Scripts/Skeleton.gd").new()# so i can add more later easily
#var slime = load("res://Scripts/Slime.gd").new()# so i can add more later easily
var evilman = load("res://EvilMan.gd").new()
var puppeteer = load("res://Scripts/Bosses scripts/Puppet1.gd").new()

var action : int
var safe = false # used to detect if blocking or dodging
var enmActions = []

func _ready():
		enmActions = [puppeteer,evilman]#add more latter
		match Global.Boss_counter:
				2:
						action = 0
						boss_banner.emit(3)
						change_stats(750,20,1,5.0, 5.0, 0)
						animated_sprite_2d.play("Puppeteer1Idle")
						pass#change sprites for scertain enemys(reason why their split is also because of the amount of>
				5:
						action = 1
						boss_banner.emit(5)
						change_stats(1160,30,1,5.0, 5.0, 0)
						animated_sprite_2d.play("EvileIdle")
						pass
						


func _on_timer_timeout() -> void:
		enmActions[action].call("Actions", self)

func change_stats(hp,sta,pow,max,min, blockchance):
	Global.bosses.health = hp
	Global.bosses.stamina = sta
	Global.bosses.power = pow
	Global.bosses.difficultyMax = max
	Global.bosses.difficultyMin = min
	Global.enemy_max = hp
	Global.bosses.block_chance= blockchance
	pass
