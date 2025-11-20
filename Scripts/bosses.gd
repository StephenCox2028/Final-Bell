extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@export var health = 1
@export var stamina = 1
@export var power = 1
		#examples for bosses
#var skeletin = load("res://Scripts/Skeleton.gd").new()# so i can add more later easily
#var slime = load("res://Scripts/Slime.gd").new()# so i can add more later easily
var spider = load("res://Scripts/Bosses scripts/Spider.gd").new()
var puppeteer = load("res://Scripts/Bosses scripts/Puppet1.gd").new()
var racoon = load("res://Scripts/Bosses scripts/Racoon.gd").new()
var action : int
var safe = false # used to detect if blocking or dodging
var enmActions = []

func _ready():
		enmActions = [puppeteer]#add more latter

		match Global.Boss_counter:
				1:
						action = 0
						change_stats(20,20,20,5.0, 5.0, 0)
						animated_sprite_2d.play("puppeteerIdle")
						pass#change sprites for scertain enemys(reason why their split is also because of the amount of>
				2:
						action = 0
						change_stats(20,20,20,5.0, 5.0, 0)
						animated_sprite_2d.play("puppeteerIdle")
						pass
				3:
						action = 0
						change_stats(20,20,20,5.0, 5.0, 0)
						animated_sprite_2d.play("puppeteerIdle")
						pass


func _on_timer_timeout() -> void:
		enmActions[action].call("Actions", self)

func change_stats(hp,sta,pow,max,min, blockchance):
	Global.bosses.health 		= hp
	Global.bosses.stamina 		= sta
	Global.bosses.power 		= pow
	Global.bosses.difficultyMax = max
	Global.bosses.difficultyMin = min
	Global.enemy_max = hp
	Global.bosses.block_chance= blockchance
	pass
