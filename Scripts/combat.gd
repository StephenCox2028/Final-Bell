extends Node2D
@onready var animation: AnimationPlayer = $Animation
@export var isdodge = true # is your ability to get hit(if not dodgeing you can get smacked)
@export var canmove = true # is your inability to move(if you cant move you cant dodge)


func _process(delta):
	if canmove == true:# this is if your able to move so attacks and the like go here
		if Input.is_action_pressed("dodgeright"):
			animation.play("dodgeright")
			
			# start timer for protection OR instead make it do a thing at the end of the animation
			pass
		if Input.is_action_pressed("dodgeleft"):
			animation.play("dodgeleft")
			# start timer for protection OR instead make it do a thing at the end of the animation
			pass
