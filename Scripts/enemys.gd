extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
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
			change_stats(1,2,3)
			animated_sprite_2d.play("SkeleDefault")# we can change this to be other enemys later
			pass#change sprites for scertain enemys(reason why their split is also because of the amount of animations in one play would make us depresed)
		2:
			action = 1
			change_stats(4,5,6)
			animated_sprite_2d.play("TempDefault")
			pass# same here

func _on_timer_timeout() -> void:	
	enmActions[action].call("Actions", self)

func change_stats(hp,sta,pow):
	health = hp
	stamina = sta
	power = pow
