extends Node2D
@onready var animation: AnimationPlayer = $Animation
@onready var character = $Character
@export var isdodge = false # is your ability to get hit(if not dodgeing you can get smacked) -Stephen
@export var ispunch = false # is your boolean for punching. - Stephen
@export var isHolding = false #is your boolean for holding down a button - Stephen
@export var canmove = true # is your inability to move(if you cant move you cant dodge) - Stephen

var originalPos = Vector2(588.0, 401.0)		#Original position of the character. - Stephen
const HOLD_TIME_THRESHOLD = 0.5
const SHAKE_STRENGTH = 10.0		#Strength and intensity of player shaking. - Stephen
var heldTime = 0

#Dictionary value that carries the time intervals for each attack. It starts with a negative number
#to allow for a longer press to be able to hook. - Stephen
var pressTimes = {
	"leftAttack": -1.0,
	"rightAttack": -1.0
}

#Player stats - Mirza
var playerStats = {
	"health" : 40,
	"stamina" : 10,
	"power" : 10
}

#boss stats - Mirza
var bosses = {
	"Hit-Man Skeleton":{"health" : 40, "stamina" : 30, "power" : 5}, #all stats are just placeholders for know
	"Devil": {"health" : 100, "stamina" : 50, "power" : 50} #all stats are just placeholders for know
}


#Player dodge and attack inputs - Stephen
func _input(event):
	if Input.is_action_just_pressed("dodgeright"):
		if canmove == true: # this is if you're able to move so attacks and the like go here 
			if isdodge == false: #this is if you're dodging or not.
				if isHolding == false:
					animation.play("dodgeright")
					pass
	if Input.is_action_just_pressed("dodgeleft"):
		if canmove == true: # this is if you're able to move so attacks and the like go here
			if isdodge == false: #this is if you're dodging or not.
				if isHolding == false:
					animation.play("dodgeleft")
					pass

	if Input.is_action_pressed("attackLeft"):
		if isHolding == false:	#If Q is not being held down.
			pressTimes["leftAttack"] = Time.get_ticks_msec() / 1000.0	#Tracks the total time that the process has been running.
			isHolding = true
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]	#Tracks the time that Q has been held by subtracting the present process time to the time that Q was first held down.
		if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:	#If Q has been held longer than the HOLD_TIME_THRESHOLD... 
			start_shake()	#Run the shaking function.
			heldTime = 0	#Set heldTime back to 0. 
	if Input.is_action_just_released("attackLeft"):
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]
		if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:	#If the hold time is less than the HOLD_TIME_THRESHOLD 
			animation.play("punch") #Simply punch
		heldTime = 0		#Reset holdTime
		isHolding = false
		if character.position != originalPos:	#If the character position is not at it's original...
			character.position = originalPos	#Reset the position after shaking.
			animation.play("punch")

	if Input.is_action_pressed("attackRight"):
		if isHolding == false:	#If E is not being held down.
			pressTimes["rightAttack"] = Time.get_ticks_msec() / 1000.0		#Tracks the total time that the process has been running.
			isHolding = true
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]	#Tracks the time that Q has been held by subtracting the present process time to the time that E was first held down.
		if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:	#If E has been held longer than the HOLD_TIME_THRESHOLD...
			start_shake()	#Run the shaking function.
			heldTime = 0	#Set heldTime back to 0.
	if Input.is_action_just_released("attackRight"):
		heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]
		if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:	#If the hold time is less than the HOLD_TIME_THRESHOLD
			animation.play("punch")	#Simply punch
		heldTime = 0	#Resets holdTime
		isHolding = false
		if character.position != originalPos:	#If the character position is not at it's original...
			character.position = originalPos	#Reset the position after shaking.
			animation.play("punch")
			
#shake hook animation - Stephen
func start_shake():
	#This line changes the character position from it's original to a random Vector2 depending on the shake strength. Since the function repeatedly runs
	#while either Q or E is held down, it looks like the character is shaking, but in reality the character is shifting positions quickly.
	character.position = originalPos + Vector2(randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH), randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH))
	await get_tree().process_frame	#Waits for the next frame.

	if isHolding:	#If the player is still holding down a key, repeat the function.
		start_shake()

#when player health reaches 0 change to a new scene - Mirza
func win_conditions(health):
	if(playerStats[health] <= 0):
		get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
	else:
		"""
		to change scene to loker room
		get._tree().change_scene_to_file()
		"""
	
	
