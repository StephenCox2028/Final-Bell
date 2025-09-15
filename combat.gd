extends Node2D
@onready var animation: AnimationPlayer = $Animation
@export var isdodge = false # is your ability to get hit(if not dodgeing you can get smacked)
@export var ispunch = false # is your boolean for punching.
@export var canmove = true # is your inability to move(if you cant move you cant dodge)

func _process(delta):
	if Input.is_action_pressed("dodgeright"):
		if canmove == true: # this is if you're able to move so attacks and the like go here
			if isdodge == false: #this is if you're dodging or not.
				animation.play("dodgeright")
				pass
	if Input.is_action_pressed("dodgeleft"):
		if canmove == true: # this is if you're able to move so attacks and the like go here
			if isdodge == false: #this is if you're dodging or not.
				animation.play("dodgeleft")
				pass
	if Input.is_action_pressed("punch"):
		if canmove == true: # this is if you're able to move so attacks and the like go here
			if isdodge == false: #this is if you're dodging or not.
				animation.play("punch")
				pass
