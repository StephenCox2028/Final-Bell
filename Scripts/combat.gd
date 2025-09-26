extends Node2D
@onready var animation: AnimationPlayer = $Animation
@onready var character = $Character
@export var isdodge = false # is your ability to get hit(if not dodgeing you can get smacked)
@export var ispunch = false # is your boolean for punching.
@export var isHoldingHook = false
@export var canmove = true # is your inability to move(if you cant move you cant dodge)

func _process(_delta):
	if Input.is_action_just_pressed("dodgeright"):
		if canmove == true: # this is if you're able to move so attacks and the like go here
			if isdodge == false: #this is if you're dodging or not.
				animation.play("dodgeright")
				pass
	if Input.is_action_just_pressed("dodgeleft"):
		if canmove == true: # this is if you're able to move so attacks and the like go here
			if isdodge == false: #this is if you're dodging or not.
				animation.play("dodgeleft")
				pass
	if Input.is_action_pressed("hook"):
		if canmove == true:
			if isdodge == false:
				if isHoldingHook == false:
					isHoldingHook = true
					start_shake()
	else:
		isHoldingHook = false
	if Input.is_action_just_pressed("punch"):
		if canmove == true: # this is if you're able to move so attacks and the like go here
			if isdodge == false: #this is if you're dodging or not.
				animation.play("punch")
				pass

func start_shake():
	if not isHoldingHook:
		animation.play("punch")
		return
	var originalPos = character.position
	var shakeStrength = 10.0
	var shakeDuration = 0.2
	
	var tween = character.create_tween()
	tween.tween_property(character, "position", originalPos + Vector2(-shakeStrength, 0), shakeDuration / 2)
	tween.tween_property(character, "position", originalPos + Vector2(shakeStrength, 0), shakeDuration / 2)
	tween.tween_property(character, "position", originalPos + Vector2(0, -shakeStrength), shakeDuration / 2)
	tween.tween_property(character, "position", originalPos + Vector2(0, shakeStrength), shakeDuration / 2)
	tween.tween_property(character, "position", originalPos, shakeDuration / 2)
	await tween.finished
	start_shake()
