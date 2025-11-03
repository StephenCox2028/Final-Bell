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
var bear = load("res://Scripts/Bosses scripts/Bear.gd").new()
var racoon = load("res://Scripts/Bosses scripts/Racoon.gd").new()
var action : int
var safe = false # used to detect if blocking or dodging
var enmActions = []

func _ready():
	enmActions = [spider, bear, racoon]#add more latter
	
	match Global.Boss_counter:
		1:
			action = 0
			
			$Sprite2D.play("Spider")
			change_stats(20,20,20)
			# we can change this to be other enemys later
			pass#change sprites for scertain enemys(reason why their split is also because of the amount of animations in one play would make us depresed)
		2:
			action = 1
			$Sprite2D.play("bear")
			change_stats(30,230,230)
		3:
			action = 2
			$Sprite2D.play("racoon")
			change_stats(240,420,420)


func _on_timer_timeout() -> void:	
	enmActions[action].call("Actions", self)

func change_stats(hp,sta,pow):
	health = hp
	stamina = sta
	power = pow
