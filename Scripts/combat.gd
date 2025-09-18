extends Node2D
@onready var animation: AnimationPlayer = $Animation
@onready var character = $Character
@export var isdodge = false # is your ability to get hit(if not dodgeing you can get smacked)
@export var ispunch = false # is your boolean for punching.
@export var isHolding = false
@export var canmove = true # is your inability to move(if you cant move you cant dodge)

var originalPos = Vector2(588.0, 401.0)
const HOLD_TIME_THRESHOLD = 0.5
const SHAKE_STRENGTH = 10.0
var heldTime = 0

var pressTimes = {
	"leftAttack": -1.0,
	"rightAttack": -1.0
}

func _input(event):
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
		
	if Input.is_action_pressed("attackLeft"):
		if isHolding == false:
			pressTimes["leftAttack"] = Time.get_ticks_msec() / 1000.0
			isHolding = true
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]
		if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:
			start_shake()
			heldTime = 0
	if Input.is_action_just_released("attackLeft"):
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]
		if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:
			animation.play("punch")
		heldTime = 0
		isHolding = false
		if character.position != originalPos:
			character.position = originalPos
			animation.play("punch")
		
	if Input.is_action_pressed("attackRight"):
		if isHolding == false:
			pressTimes["rightAttack"] = Time.get_ticks_msec() / 1000.0
			isHolding = true
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]
		if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:
			start_shake()
			heldTime = 0
	if Input.is_action_just_released("attackRight"):
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]
		if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:
			animation.play("punch")
		heldTime = 0
		isHolding = false
		if character.position != originalPos:
			character.position = originalPos
			animation.play("punch")
	
func start_shake():
	character.position = originalPos + Vector2(randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH), randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH))
	await get_tree().process_frame

	if isHolding:
		start_shake()
