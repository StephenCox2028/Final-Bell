extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var skeletin = load("res://Scripts/Skeleton.gd").new()# so i can add more later easily
var slime = load("res://Scripts/Slime.gd").new()# so i can add more later easily


var enmActions = []

var rng = RandomNumberGenerator.new()
var action : int
var boss
func _ready():
	enmActions = [skeletin,slime]#add more latter
	timer.timeout.connect(_on_timer_timeout)
	boss = randi_range(1, 2)
	match boss:
		1:
			animated_sprite_2d.play("Default")# we can change this to be other enemys later
			pass#change sprites for scertain enemys(reason why their split is also because of the amount of animations in one play would make us depresed)
		2:
			animated_sprite_2d.play("TempDefault")
			pass# same here

func _on_timer_timeout() -> void:
	action = randi_range(0, enmActions.size() - 1)
	enmActions[action].call("Actions", self)
