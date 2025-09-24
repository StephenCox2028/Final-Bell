extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var skeletin = load("res://Scripts/Skeleton.gd").new()# so i can add more later easily
var slime = load("res://Scripts/Slime.gd").new()# so i can add more later easily

var enmActions = []

var rng = RandomNumberGenerator.new()
var action : int
var enemy
func _ready():
	enmActions = [skeletin,slime]#add more latter
	timer.timeout.connect(_on_timer_timeout)
	enemy = randi_range(1, 2)

	match enemy:
		1:
			action = 0
			animated_sprite_2d.play("SkeleDefault")# we can change this to be other enemys later
			pass#change sprites for scertain enemys(reason why their split is also because of the amount of animations in one play would make us depresed)
		2:
			action = 1
			animated_sprite_2d.play("TempDefault")
			pass# same here

func _on_timer_timeout() -> void:	
	enmActions[action].call("Actions", self)
